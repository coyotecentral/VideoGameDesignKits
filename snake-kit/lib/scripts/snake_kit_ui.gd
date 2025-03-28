extends Control
class_name SnakeGameUI

var score_label: Label:
	get:
		return $UI/MarginContainer/HBoxContainer/Score/Value