#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { parse: parseJsonc, printParseErrorCode } = require("jsonc-parser");

const ROOT_DIR = path.resolve(__dirname, "..");
const SRC_DIR = path.join(ROOT_DIR, "src", "themes");
const OUT_DIR = path.join(ROOT_DIR, "themes");
const PACKAGE_JSON_PATH = path.join(ROOT_DIR, "package.json");

function readJson(filePath) {
  const raw = fs.readFileSync(filePath, "utf8");
  const errors = [];
  const data = parseJsonc(raw, errors, {
    allowTrailingComma: true,
    disallowComments: false,
  });

  if (errors.length > 0) {
    const lines = raw.split("\n");
    const details = errors
      .map((e) => {
        const upTo = raw.slice(0, e.offset);
        const line = upTo.split("\n").length;
        const col = e.offset - upTo.lastIndexOf("\n");
        return `  - ${printParseErrorCode(e.error)} на строке ${line}, столбце ${col}`;
      })
      .join("\n");
    throw new Error(`Ошибки при разборе ${filePath}:\n${details}`);
  }

  return data;
}

function deepClone(value) {
  return value === undefined ? value : JSON.parse(JSON.stringify(value));
}

function isPlainObject(value) {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function scopeKey(scope) {
  if (scope === undefined || scope === null) return "";
  const list = Array.isArray(scope) ? scope : [scope];
  return list
    .map((s) => String(s).trim())
    .sort()
    .join(",");
}

function mergeTokenColors(baseArr, overrideArr) {
  const base = deepClone(baseArr) || [];
  const indexByKey = new Map();
  base.forEach((rule, idx) => indexByKey.set(scopeKey(rule.scope), idx));

  for (const rule of overrideArr || []) {
    const key = scopeKey(rule.scope);
    if (indexByKey.has(key)) {
      const idx = indexByKey.get(key);
      base[idx] = {
        ...base[idx],
        ...rule,
        settings: deepMerge(base[idx].settings || {}, rule.settings || {}),
      };
    } else {
      base.push(deepClone(rule));
      indexByKey.set(key, base.length - 1);
    }
  }

  return base;
}

function deepMerge(target, source) {
  const result = isPlainObject(target) ? { ...target } : {};

  for (const key of Object.keys(source || {})) {
    const sourceValue = source[key];

    if (key === "tokenColors" && Array.isArray(sourceValue)) {
      result[key] = mergeTokenColors(result[key], sourceValue);
      continue;
    }

    if (isPlainObject(sourceValue) && isPlainObject(result[key])) {
      result[key] = deepMerge(result[key], sourceValue);
      continue;
    }

    result[key] = deepClone(sourceValue);
  }

  return result;
}

function loadSourceThemes() {
  if (!fs.existsSync(SRC_DIR)) {
    throw new Error(`Папка с исходниками не найдена: ${SRC_DIR}`);
  }

  const files = fs.readdirSync(SRC_DIR).filter((f) => f.endsWith(".json"));
  if (files.length === 0) {
    throw new Error(`В ${SRC_DIR} нет ни одного .json файла`);
  }

  const sources = new Map(); // id -> { data, filePath }
  for (const file of files) {
    const id = file.replace(/\.json$/, "");
    const filePath = path.join(SRC_DIR, file);
    sources.set(id, { data: readJson(filePath), filePath });
  }

  return sources;
}

function resolveChain(id, sources) {
  const chain = [];
  const seen = new Set();
  let current = id;

  while (current) {
    if (seen.has(current)) {
      const cycle = [...chain, current].join(" -> ");
      throw new Error(`Обнаружено циклическое наследование тем: ${cycle}`);
    }
    seen.add(current);

    const entry = sources.get(current);
    if (!entry) {
      throw new Error(
        `Тема "${id}" ссылается на несуществующего родителя "${current}". ` +
          `Проверьте, что файл ${current}.json существует в src/themes/.`
      );
    }

    chain.unshift(current);
    current = entry.data.parent;
  }

  return chain;
}

function buildTheme(id, sources) {
  const chain = resolveChain(id, sources);

  let merged = {};
  for (const ancestorId of chain) {
    merged = deepMerge(merged, sources.get(ancestorId).data);
  }

  delete merged.parent;
  return merged;
}

const TYPE_TO_UI_THEME = {
  light: "vs",
  dark: "vs-dark",
  "hc-black": "hc-black",
  "hc-light": "hc-light",
};

function updatePackageJson(builtThemes) {
  if (!fs.existsSync(PACKAGE_JSON_PATH)) {
    console.warn(`package.json не найден по пути ${PACKAGE_JSON_PATH}, пропускаю обновление.`);
    return;
  }

  const pkg = readJson(PACKAGE_JSON_PATH);
  pkg.contributes = pkg.contributes || {};

  pkg.contributes.themes = builtThemes.map(({ id, data }) => {
    const uiTheme = TYPE_TO_UI_THEME[data.type];
    if (!uiTheme) {
      console.warn(
        `Тема "${id}" имеет неизвестный или отсутствующий "type" (${data.type}). ` +
          `Ожидались: ${Object.keys(TYPE_TO_UI_THEME).join(", ")}. Использую "vs-dark".`
      );
    }
    return {
      label: data.name || id,
      uiTheme: uiTheme || "vs-dark",
      path: `./themes/${id}.json`,
    };
  });

  fs.writeFileSync(PACKAGE_JSON_PATH, JSON.stringify(pkg, null, 2) + "\n", "utf8");
}

function build() {
  const sources = loadSourceThemes();

  if (!fs.existsSync(OUT_DIR)) {
    fs.mkdirSync(OUT_DIR, { recursive: true });
  }

  const builtThemes = [];

  for (const id of sources.keys()) {
    const data = buildTheme(id, sources);
    const outPath = path.join(OUT_DIR, `${id}.json`);
    fs.writeFileSync(outPath, JSON.stringify(data, null, 2) + "\n", "utf8");
    builtThemes.push({ id, data });
    console.log(`✓ ${id}.json`);
  }

  updatePackageJson(builtThemes);
  console.log(`\nСобрано тем: ${builtThemes.length}. package.json обновлён.`);
}

try {
  build();
} catch (err) {
  console.error("\n✗ Сборка тем провалилась:");
  console.error(err.message);
  process.exit(1);
}
