#!/usr/bin/env node
"use strict";

const path = require("path");
const { execFileSync } = require("child_process");
const chokidar = require("chokidar");

const ROOT_DIR = path.resolve(__dirname, "..");
const SRC_GLOB = path.join(ROOT_DIR, "src", "themes", "*.json");
const BUILD_SCRIPT = path.join(__dirname, "build-themes.js");

function runBuild() {
  const time = new Date().toLocaleTimeString();
  console.log(`\n[${time}] Изменения обнаружены, пересобираю темы...`);
  try {
    execFileSync(process.execPath, [BUILD_SCRIPT], { stdio: "inherit" });
  } catch {

	}
}

console.log(`Слежу за ${SRC_GLOB}`);
runBuild();

chokidar
  .watch(SRC_GLOB, { ignoreInitial: true })
  .on("add", runBuild)
  .on("change", runBuild)
  .on("unlink", runBuild);
