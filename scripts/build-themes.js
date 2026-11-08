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

const TEMPLATE_ONLY_KEYS = ["parents", "theme_postfix", "name_template"];
const ID_MARKER = "color-theme";
const VARIANT_VAR = "$variant";

function isTemplate(data) {
  return isPlainObject(data) && Object.prototype.hasOwnProperty.call(data, "parents");
}

function makeThemeId(parentId, postfix) {
  const trimDashes = (s) => s.replace(/^-+|-+$/g, "");
  const idx = parentId.lastIndexOf(ID_MARKER);
  const head = trimDashes(idx === -1 ? parentId : parentId.slice(0, idx));
  const tail = idx === -1 ? "" : parentId.slice(idx);
  return [head, trimDashes(postfix), tail].filter(Boolean).join("-");
}

function extractVariant(name, parentId) {
  const matches = [...String(name || "").matchAll(/\[([^\]]*)\]/g)];
  if (matches.length > 0) return matches[matches.length - 1][1].trim();

  console.warn(
    `У родителя "${parentId}" в названии "${name}" нет части в [], ` +
      `использую название целиком как $variant.`
  );
  return String(name || parentId);
}

function validateTemplate(templateId, data) {
  const where = `Шаблон "${templateId}"`;

  if (Object.prototype.hasOwnProperty.call(data, "parent")) {
    throw new Error(`${where}: нельзя одновременно указывать "parent" и "parents".`);
  }
  if (!Array.isArray(data.parents) || data.parents.length === 0) {
    throw new Error(`${where}: "parents" должен быть непустым массивом id тем.`);
  }
  if (!data.parents.every((p) => typeof p === "string" && p.length > 0)) {
    throw new Error(`${where}: "parents" должен содержать только непустые строки.`);
  }
  if (new Set(data.parents).size !== data.parents.length) {
    throw new Error(`${where}: в "parents" есть повторяющиеся значения.`);
  }
  if (typeof data.theme_postfix !== "string" || data.theme_postfix.replace(/-/g, "") === "") {
    throw new Error(`${where}: "theme_postfix" должен быть непустой строкой.`);
  }
  if (/[\\/]/.test(data.theme_postfix)) {
    throw new Error(`${where}: "theme_postfix" не должен содержать / или \\.`);
  }
  if (typeof data.name_template !== "string" || data.name_template.length === 0) {
    throw new Error(`${where}: "name_template" должен быть непустой строкой.`);
  }
  if (!data.name_template.includes(VARIANT_VAR)) {
    throw new Error(
      `${where}: "name_template" должен содержать ${VARIANT_VAR}, иначе у всех тем будет одинаковое название.`
    );
  }
}

function expandTemplates(sources) {
  const result = new Map();
  const templates = [];

  for (const [id, entry] of sources) {
    if (isTemplate(entry.data)) templates.push([id, entry]);
    else result.set(id, entry);
  }

  const usedNames = new Map(); // name -> id
  for (const [id, entry] of result) {
    if (entry.data.name) usedNames.set(entry.data.name, id);
  }

  for (const [templateId, template] of templates) {
    validateTemplate(templateId, template.data);

    const body = deepClone(template.data);
    for (const key of TEMPLATE_ONLY_KEYS) delete body[key];

    for (const parentId of template.data.parents) {
      if (!result.has(parentId)) {
        if (sources.has(parentId)) {
          throw new Error(
            `Шаблон "${templateId}": "${parentId}" сам является шаблоном и не может быть родителем.`
          );
        }
        throw new Error(
          `Шаблон "${templateId}": родитель "${parentId}" не найден. ` +
            `Проверьте, что файл ${parentId}.json существует в src/themes/.`
        );
      }

      const parentTheme = buildTheme(parentId, result);
      const newId = makeThemeId(parentId, template.data.theme_postfix);

      if (result.has(newId) || sources.has(newId)) {
        throw new Error(
          `Шаблон "${templateId}": итоговый id "${newId}" (из родителя "${parentId}") ` +
            `совпадает с уже существующим файлом/темой.`
        );
      }

      const variant = extractVariant(parentTheme.name, parentId);
      const name = template.data.name_template.split(VARIANT_VAR).join(variant);

      if (usedNames.has(name)) {
        throw new Error(
          `Шаблон "${templateId}": название "${name}" уже используется темой "${usedNames.get(name)}".`
        );
      }

      const data = deepClone(body);
      data.parent = parentId;
      data.name = name;

      if (data.type === "parent") {
        if (!parentTheme.type) {
          throw new Error(
            `Шаблон "${templateId}": у родителя "${parentId}" не задан "type", ` +
              `поэтому "type": "parent" разрешить нельзя.`
          );
        }
        data.type = parentTheme.type;
      }

      result.set(newId, { data, filePath: template.filePath, templateId });
      usedNames.set(name, newId);
    }
  }

  return result;
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
  const sources = expandTemplates(loadSourceThemes());

  if (!fs.existsSync(OUT_DIR)) {
    fs.mkdirSync(OUT_DIR, { recursive: true });
  }

  const builtThemes = [];

  for (const [id, entry] of sources) {
    const data = buildTheme(id, sources);
    const outPath = path.join(OUT_DIR, `${id}.json`);
    fs.writeFileSync(outPath, JSON.stringify(data, null, 2) + "\n", "utf8");
    builtThemes.push({ id, data });
    console.log(`✓ ${id}.json${entry.templateId ? `  (шаблон: ${entry.templateId})` : ""}`);
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
