import std/[json, streams, os, strformat]
import os
import print

var baseJsonFile = getAppDir() & "/base.json"
var outFile = "~/.config/karabiner/karabiner.json"

proc run() =
  if paramCount() == 0:
    return
  var baseJson = parseJson(openFileStream(baseJsonFile))
  var addJsonFile = &"{paramStr(1)}-swap.json"

  var addJson = parseJson(openFileStream(&"{getAppDir()}/{addJsonFile}"))
  baseJson["profiles"][0]["complex_modifications"]["rules"].add(addJson)

  writeFile(outFile.expandTilde, baseJson.pretty)
  writeFile("~/log.txt".expandTilde, paramStr(1))

run()
