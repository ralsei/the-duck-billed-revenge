extends Control

func _on_back_pressed():
	# Why does PackedScene not work here????????
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
