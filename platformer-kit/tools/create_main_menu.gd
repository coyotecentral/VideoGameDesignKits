#!/usr/bin/env -S godot -s
extends SceneTree

func _init() -> void:
	var level_data = scan_levels_dir()
	var ui = create_level_select(level_data)
	var scene = PackedScene.new()
	scene.pack(ui)
	ResourceSaver.save(scene, "res://autogen/auto_level_select.tscn")
	quit()

func scan_levels_dir() -> Array[LevelMeta]:
	var results: Array[LevelMeta] = []

	var dir = DirAccess.open("res://levels")

	if not dir:
		return results

	dir.list_dir_begin()
	var fname = dir.get_next()
	while fname != "":
		if dir.current_is_dir():
			results.append_array(create_level_metas("res://levels/%s" % fname))
		fname = dir.get_next()
	return results

func create_level_metas(base_path: String) -> Array[LevelMeta]:
	var results: Array[LevelMeta] = []
	var resources = ResourceLoader.list_directory(base_path)
	var scenes: PackedStringArray = []
	for r in resources:
		if r.ends_with(".tscn"):
			scenes.append(r)

	var author = base_path.split("/")[-1]
	print(author)
	for r in scenes:
		print("\t%s" % r)
		results.append(create_level_meta("%s/%s" % [base_path, r], author, r))

	return results

func create_level_meta(path: String, author: String, name: String) -> LevelMeta:
	var meta = LevelMeta.new()
	meta.author = author
	meta.level_name = name.replace("_", " ").replace("-", " ").split(".tscn")[0]
	meta.scene_uid = ResourceUID.id_to_text(ResourceLoader.get_resource_uid(path))
	return meta

func create_level_select(levels: Array[LevelMeta]) -> Node:
	var base = VBoxContainer.new()
	base.size_flags_horizontal = Control.SIZE_EXPAND

	for l in levels:
		var btn = create_level_button(l)
		base.add_child(btn, true)
		btn.set_owner(base)

	return base

func create_level_button(level: LevelMeta) -> Button:
	var btn_script = GDScript.new()
	btn_script.set_source_code("extends Button\n" \
		+"\nfunc _ready() -> void:" \
		+"\n\tpressed.connect(func():" \
		+"\n\t\tget_tree().change_scene_to_file(\"%s\")" % level.scene_uid \
		+"\n\t)\n"
		)
	var btn = Button.new()
	btn.text = "%s by %s" % [level.level_name, level.author]
	btn.set_script(btn_script)
	return btn
