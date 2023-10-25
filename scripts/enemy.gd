extends CharacterBody2D

@export var _sprite: AnimatedSprite2D
@export var _laser_tscn: PackedScene
@export var _timer: Timer

const OSCILLATE_BY = 1
const NIL_SPEED = 10.0
const SPEED_TIME_MULTIPLIER = 0.01

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var t = 0

func _process(delta):
	var timeout = lerp(1.0, 0.1, GameState.player_abs_velocity / 300)
	print(timeout)
	_timer.wait_time = timeout

func _physics_process(delta):
	var speed = GameState.player_abs_velocity + NIL_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if int(floor(t / OSCILLATE_BY)) % 2 == 0:
		velocity.x = -speed
		_sprite.flip_h = true
	else:
		velocity.x = speed
		_sprite.flip_h = false
		
	t += delta * (speed * SPEED_TIME_MULTIPLIER)

	move_and_slide()

func _on_shoot_timer_timeout():
	var new_laser = _laser_tscn.instantiate()
	add_sibling(new_laser)
	new_laser.position = self.position
