extends Area2D

const NIL_SPEED = 0.5
const SPEED_TIME_MULTIPLIER = 0.02

func _process(delta):
	var speed = (GameState.player_abs_velocity * SPEED_TIME_MULTIPLIER) + NIL_SPEED
	position.x -= speed
