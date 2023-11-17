extends Control

func _process(delta):
	if self.visible:
		if Input.is_action_just_pressed("reset"):
			GameState.reset_level()
