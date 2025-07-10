GODOT = /Applications/Godot.app/Contents/MacOS/Godot
WINDOWS_EXE_NAME = Salmon_Bay__March_2025.exe

web: main_menu
	mkdir -p build
	rm -rf build/web
	rm -rf build/web.zip
	mkdir -p build/web
	${GODOT} --headless --export-release Web build/web/index.html
	zip -r build/web.zip build/web

windows: main_menu
	mkdir -p build
	rm -rf build/windows
	mkdir -p build/windows
	${GODOT} --headless --export-release "Windows Desktop" build/windows/${WINDOWS_EXE_NAME} --embed-pck

main_menu:
	mkdir -p autogen
	${GODOT} -s tools/create_main_menu.gd
