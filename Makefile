karamake: karamake.nim
	nim c karamake.nim

install: karamake
	rm -rf ~/.config/karabiner/exts ~/.config/karabiner/subs
	cp -r exts subs karamake swap-base.json base.json ~/.config/karabiner/
	~/.config/karabiner/karamake
