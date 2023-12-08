import std/[json, streams, os, strformat, osproc, strutils]

import os
import print

var baseJsonFile = getAppDir() & "/base.json"
var baseSwapJsonFile = getAppDir() & "/swap-base.json"

var outFile = "~/.config/karabiner/karabiner.json"

proc run() =
  if paramCount() == 0:
    return

  # var currentProg = execProcess("CUR_APP=$(osascript -e 'tell application \"System Events\" to tell (first process whose frontmost is true) to return name'); CUR_CO=\"tell application \\\"System Events\\\" to POSIX path of (file of process \\\"$CUR_APP\\\" as alias)\"; osascript -e \"$CUR_CO\"").replace("\n", "")

  # var currentProg = execProcess("CUR_APP=$(osascript -e 'tell application \"System Events\" to tell (first process whose frontmost is true) to return name'); echo $CUR_APP")

  var currentProg = execProcess("lsappinfo info -only bundlepath `lsappinfo front`")
  currentProg = currentProg.replace(""""LSBundlePath"=""", "")

  var currentSpace = execProcess("""osascript -e 'tell application ¬' -e    '"System Events" to tell process ¬' -e    '"WhichSpace" to set temp to (title of menu bar items of menu bar 1)' -e 'return item 1 of temp'""")


  currentSpace = currentSpace.replace("\n", "")

  var baseJson = parseJson(openFileStream(baseJsonFile))
  var baseSwapJson = parseJson(openFileStream(baseSwapJsonFile))

  var key_code = baseSwapJson["manipulators"][0]["from"]["key_code"].getStr
  baseSwapJson["manipulators"][0]["from"]["key_code"] = %key_code.replace("#", paramStr(1))

  var space = baseSwapJson["manipulators"][0]["to"][0]["key_code"].getStr
  baseSwapJson["manipulators"][0]["to"][0]["key_code"] = %space.replace("#", currentSpace)

  var cmd = baseSwapJson["manipulators"][0]["to"][1]["shell_command"].getStr
  baseSwapJson["manipulators"][0]["to"][1]["shell_command"] = %cmd.replace("#", currentProg)

  writeFile(expandTilde(&"~/.config/karabiner/{paramStr(1)}-swap.json"), baseSwapJson.pretty)

  var f_swap = parseJson(openFileStream("~/.config/karabiner/f-swap.json".expandTilde))
  var d_swap = parseJson(openFileStream("~/.config/karabiner/d-swap.json".expandTilde))

  baseJson["profiles"][0]["complex_modifications"]["rules"].add(f_swap)
  baseJson["profiles"][0]["complex_modifications"]["rules"].add(d_swap)

  writeFile(outFile.expandTilde, baseJson.pretty)

run()
