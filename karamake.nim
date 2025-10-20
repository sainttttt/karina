import std/[json, streams, os, strformat, osproc, strutils]

import os
import print
import glob
import regex

var baseJsonFile = getAppDir() & "/base.json"
var baseSwapJsonFile = getAppDir() & "/swap-base.json"

var outFile = "~/.config/karabiner/karabiner.json"


proc jsonSub(m: RegexMatch2, s: string): string =
  let f = s[m.group(0)]
  result = readFile(getAppDir() & "/subs/" & fmt"{f}.json")

proc genKaraJson(addSubs = false, write = false): JsonNode =
  var baseJson = parseJson(openFileStream(baseJsonFile))
  for path in walkGlob(getAppDir() & "/exts/*.json"):
    let extRules = parseJson(openFileStream(path))
    for r in extRules:
      let repJson = parseJson(($r).replace(re2""""##(\w+)"""", jsonSub))
      baseJson["profiles"][0]["complex_modifications"]["rules"].add(repJson)

  if addSubs:
    for path in walkGlob("~/.config/karabiner/*-swap.json".expandTilde):
      baseJson["profiles"][0]["complex_modifications"]["rules"]
      .add(parseJson(openFileStream(path)))

  if write:
    writeFile(outFile.expandTilde, baseJson.pretty)
    echo "reloaded karabiner config"

  return baseJson

proc run() =

  if paramCount() == 0:
    discard genKaraJson(write = true, addSubs = true)
    return


  var currentProg = execProcess("lsappinfo info -only bundlepath `lsappinfo front`")
  currentProg = currentProg.replace(""""LSBundlePath"=""", "")

  var currentSpace = execProcess("""osascript -e 'tell application ¬' -e    '"System Events" to tell process ¬' -e    '"WhichSpace" to set temp to (title of menu bar items of menu bar 1)' -e 'return item 1 of temp'""")

  currentSpace = currentSpace.replace("\n", "")

  var baseJson = genKaraJson(addSubs = false)
  writeFile(expandTilde(&"~/karalog1.json"), baseJson.pretty)

  var baseSwapJson = parseJson(openFileStream(baseSwapJsonFile))

  var key_code = baseSwapJson["manipulators"][0]["from"]["key_code"].getStr
  baseSwapJson["manipulators"][0]["from"]["key_code"] = %key_code.replace("#", paramStr(1))

  var space = baseSwapJson["manipulators"][0]["to"][0]["key_code"].getStr
  baseSwapJson["manipulators"][0]["to"][0]["key_code"] = %space.replace("#", currentSpace)

  var cmd = baseSwapJson["manipulators"][0]["to"][1]["shell_command"].getStr
  baseSwapJson["manipulators"][0]["to"][1]["shell_command"] = %cmd.replace("#", currentProg)

  # read all the swap slot config files and add them to our main json variable before
  # writing out
  writeFile(expandTilde(&"~/.config/karabiner/{paramStr(1)}-swap.json"), baseSwapJson.pretty)
  for path in walkGlob("~/.config/karabiner/*-swap.json".expandTilde):
    baseJson["profiles"][0]["complex_modifications"]["rules"]
    .add(parseJson(openFileStream(path)))

  writeFile(outFile.expandTilde, baseJson.pretty)


run()
