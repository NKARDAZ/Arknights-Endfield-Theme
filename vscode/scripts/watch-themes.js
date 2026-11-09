#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");
const chokidar = require("chokidar");

const ROOT_DIR = path.resolve(__dirname, "..");
const SRC_DIR = path.join(ROOT_DIR, "src", "themes");
const BUILD_SCRIPT = path.join(__dirname, "build-themes.js");

if (!fs.existsSync(SRC_DIR)) {
  console.error(`Папка не найдена: ${SRC_DIR}`);
  process.exit(1);
}

let building = false;
let pendingRebuild = false;

function runBuild(eventPath) {
  if (building) {
    pendingRebuild = true;
    return;
  }

  building = true;
  const time = new Date().toLocaleTimeString();
  const label = eventPath ? path.basename(eventPath) : "инициализация";
  console.log(`\n[${time}] Изменения (${label}), пересобираю темы...`);

  try {
    execFileSync(process.execPath, [BUILD_SCRIPT], { stdio: "inherit" });
  } catch {
  } finally {
    building = false;
    if (pendingRebuild) {
      pendingRebuild = false;
      runBuild();
    }
  }
}

console.log(`Слежу за ${SRC_DIR}`);
runBuild();

const watcher = chokidar.watch(SRC_DIR, {
  ignoreInitial: true,
  awaitWriteFinish: {
    stabilityThreshold: 150,
    pollInterval: 50,
  },
});

function isJson(filePath) {
  return filePath.toLowerCase().endsWith(".json");
}

watcher
  .on("add", (p) => isJson(p) && runBuild(p))
  .on("change", (p) => isJson(p) && runBuild(p))
  .on("unlink", (p) => isJson(p) && runBuild(p))
  .on("error", (err) => console.error("Ошибка watcher'а:", err));
