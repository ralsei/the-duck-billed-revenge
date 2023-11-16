extends Area2D

@export var _sprite: Sprite2D

const NIL_SPEED = 0.5
const SPEED_TIME_MULTIPLIER = 0.02

var direction = Vector2.LEFT
var _parried = false

func set_direction(dir: Vector2):
	direction = dir
	_sprite.rotation = PI - dir.angle()

func parry():
	if not _parried:
		set_direction(-direction)
		_parried = true

func _physics_process(delta):
	var speed = (GameState.player_abs_velocity * SPEED_TIME_MULTIPLIER) + NIL_SPEED
	self.position = self.position + (speed * direction)

func _on_body_entered(body: Node2D):
	if body.is_in_group("character"):
		body.die()
	else:
		# ostensibly a wall
		queue_free()
