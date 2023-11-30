karamake: karamake.nim karamake2.nim
	nim c karamake.nim
	nim c karamake2.nim

install:
	cp karamake karamake2 *.json ~/bin/karamake/
