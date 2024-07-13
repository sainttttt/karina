karamake: karamake.nim
	nim c karamake.nim

install: karamake
	rm -rf ~/bin/karamake/ext
	cp -r ext karamake base.json ~/bin/karamake/
	~/bin/karamake/karamake
