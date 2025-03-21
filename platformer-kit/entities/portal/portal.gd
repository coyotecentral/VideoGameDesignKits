@tool
extends Node2D
class_name Portal

@export_enum("Portal", "Scene") var destination: String = "Portal":
	set(v):
		destination = v
		property_list_changed.emit()

@export var disabled := false

var _other_portal: NodePath = ""
var _level_scene_path: String = ""

signal teleport(position: Vector2)
signal scene_change(path: String)

func _ready() -> void:
	$Area2D.area_entered.connect(_handle_area_entered)
	$Area2D.body_entered.connect(_handle_area_entered)
	$Area2D.body_exited.connect(_handle_area_exited)
	$Area2D.area_exited.connect(_handle_area_exited)

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []

	if destination == "Portal":
		properties.append({
			"name": "other_portal",
			"type": TYPE_NODE_PATH,
		})
	if destination == "Scene":
		properties.append({
			"name": "scene_path",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tscn"
		})

	return properties

func _get(property: StringName) -> Variant:
	if property == "other_portal":
		return _other_portal
	if property == "scene_path":
		return _level_scene_path
	else:
		return null

func _set(property: StringName, value: Variant) -> bool:
	if property == "other_portal":
		if value:
			_other_portal = value
		else:
			_other_portal = ""
	if property == "scene_path":
		if value:
			_level_scene_path = value
		else:
			_level_scene_path = ""

	return false

func _handle_area_entered(node: Node2D):
	if disabled:
		return
	if _other_portal != ^"" or _level_scene_path != "":
			var parent = node.get_parent()
			if node is Player or parent is Player:
				if destination == "Portal":
						var portal = get_node(_other_portal)
						portal.disabled = true
						teleport.emit(portal.global_position)
				if destination == "Scene":
					scene_change.emit(_level_scene_path)

func _handle_area_exited(node: Node2D):
	var parent = node.get_parent()
	if node is Player or parent is Player:
		if disabled:
			disabled = false