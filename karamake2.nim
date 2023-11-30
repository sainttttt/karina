import std/[json, streams, os, strformat, osproc, strutils]

import os
import print

var baseJsonFile = getAppDir() & "/base.json"
var baseSwapJsonFile = getAppDir() & "/swap-base.json"

var outFile = "~/.config/karabiner/karabiner.json"

proc run() =
  if paramCount() == 0:
    return

  var currentProg = execProcess("CUR_APP=$(osascript -e 'tell application \"System Events\" to tell (first process whose frontmost is true) to return name'); CUR_CO=\"tell application \\\"System Events\\\" to POSIX path of (file of process \\\"$CUR_APP\\\" as alias)\"; osascript -e \"$CUR_CO\"").replace("\n", "")

  print currentProg


  var baseJson = parseJson(openFileStream(baseJsonFile))
  var baseSwapJson = parseJson(openFileStream(baseSwapJsonFile))

  var key_code = baseSwapJson["manipulators"][0]["from"]["key_code"].getStr
  baseSwapJson["manipulators"][0]["from"]["key_code"] = %key_code.replace("#", paramStr(1))

  var cmd = baseSwapJson["manipulators"][0]["to"][1]["shell_command"].getStr
  baseSwapJson["manipulators"][0]["to"][1]["shell_command"] = %cmd.replace("#", currentProg)

  writeFile(expandTilde(&"~/.config/karabiner/{paramStr(1)}-swap.json"), baseSwapJson.pretty)

  var f_swap = parseJson(openFileStream("~/.config/karabiner/f-swap.json".expandTilde))
  var d_swap = parseJson(openFileStream("~/.config/karabiner/d-swap.json".expandTilde))

  baseJson["profiles"][0]["complex_modifications"]["rules"].add(f_swap)
  baseJson["profiles"][0]["complex_modifications"]["rules"].add(d_swap)

  writeFile(outFile.expandTilde, baseJson.pretty)

  writeFile("~/log2.txt".expandTilde, baseSwapJson.pretty)

run()
