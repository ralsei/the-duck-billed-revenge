extends CharacterBody2D

@export var _sprite: AnimatedSprite2D
@export var _laser_tscn: PackedScene
@export var _timer: Timer
@export var _oscillate_by := 50

enum EnemyState {
	LEFT,
	RIGHT,
	SHOOTING # stationary, shooting the gun
}

const NIL_SPEED = 10.0
const SPEED_TIME_MULTIPLIER = 0.01
const BULLET_OFFSET_X = -17.0
const BULLET_OFFSET_Y = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _init_x_pos := 0
var _state: EnemyState = EnemyState.RIGHT

func die():
	self.queue_free()

func _ready():
	_init_x_pos = self.position.x
	
	_sprite.play("default")

func _process(delta):
	# TODO: tune, prolly have this change w delta, KILL GOD, DIE
	var timeout = lerp(2.5, 0.5, GameState.player_abs_velocity / 300)
	_timer.wait_time = timeout
	
	if _state == EnemyState.RIGHT:
		_sprite.flip_h = true
	elif _state == EnemyState.LEFT:
		_sprite.flip_h = false

func _physics_process(delta):
	var speed = GameState.player_abs_velocity + NIL_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var x_moved_by = self.position.x - _init_x_pos
	
	if x_moved_by > _oscillate_by:
		_state = EnemyState.LEFT
	elif x_moved_by < -_oscillate_by:
		_state = EnemyState.RIGHT
		
	if _state == EnemyState.LEFT:
		velocity.x = -speed
	elif _state == EnemyState.RIGHT:
		velocity.x = speed

	move_and_slide()

func _on_shoot_timer_timeout():
	var new_laser = _laser_tscn.instantiate()
	add_sibling(new_laser)
	
	new_laser.position.y = self.position.y + BULLET_OFFSET_Y
	new_laser.position.x = self.position.x + BULLET_OFFSET_X
	
	_sprite.play("attack")

func _on_animated_sprite_2d_animation_looped():
	if _sprite.animation == "attack":
		_sprite.play("default")
