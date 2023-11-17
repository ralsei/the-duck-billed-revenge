extends Node

var player_abs_velocity: float = 0
var n_enemies = 0
var current_level = 1

const NUM_LEVELS = 1

func is_level_over():
	return n_enemies == 0

func advance_level():
	current_level += 1
	if current_level > NUM_LEVELS:
		get_tree().change_scene_to_file("res://scenes/complete.tscn")
	else:
		var new_level = "res://scenes/level%s.tscn" % current_level
		get_tree().change_scene_to_file(new_level)

func reset_level():
	n_enemies = 0
	player_abs_velocity = 0
	
	var new_level = "res://scenes/level%s.tscn" % current_level
	get_tree().change_scene_to_file(new_level)
