extends Control

@export var _level: PackedScene
@export var _help: PackedScene

func _on_play_pressed():
	get_tree().change_scene_to_packed(_level)

func _on_help_pressed():
	get_tree().change_scene_to_packed(_help)

func _on_exit_pressed():
	get_tree().quit()
