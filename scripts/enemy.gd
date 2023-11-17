extends CharacterBody2D

@export var _player: CharacterBody2D
@export var _sprite: AnimatedSprite2D
@export var _laser_tscn: PackedScene
@export var _timer: Timer
@export var _raycast: RayCast2D
@export var _oscillate_by := 50
@export var _max_distance := 150
@export var _fov := 45

enum EnemyState {
	MOVING,
	SHOOTING # stationary, shooting the gun
}

const NIL_SPEED = 10.0
const SPEED_TIME_MULTIPLIER = 0.01
const BULLET_OFFSET_X = -17.0
const BULLET_OFFSET_Y = 3.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _init_x_pos := 0
var _state: EnemyState = EnemyState.MOVING
var _sprite_flip := Enums.SpriteFlip.RIGHT
var _currently_shooting := false

func die():
	GameState.n_enemies -= 1
	self.queue_free()

func _ready():
	GameState.n_enemies += 1
	_init_x_pos = self.position.x
	_sprite.play("default")

func _process(delta):
	var timeout = lerp(0.8, 0.2, GameState.player_abs_velocity / 300)
	_timer.wait_time = timeout
	
	if _sprite_flip == Enums.SpriteFlip.RIGHT:
		_sprite.flip_h = true
	elif _sprite_flip == Enums.SpriteFlip.LEFT:
		_sprite.flip_h = false

	if _state == EnemyState.SHOOTING and not _currently_shooting:
		_timer.start()
		_currently_shooting = true
		_on_shoot_timer_timeout() # call directly immediately
	elif _state == EnemyState.MOVING:
		_timer.stop()
		_currently_shooting = false

func _physics_process(delta):
	var speed = GameState.player_abs_velocity + NIL_SPEED
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if _state == EnemyState.MOVING:
		var x_moved_by = self.position.x - _init_x_pos
	
		if x_moved_by > _oscillate_by:
			_sprite_flip = Enums.SpriteFlip.LEFT
		elif x_moved_by < -_oscillate_by:
			_sprite_flip = Enums.SpriteFlip.RIGHT

		if _sprite_flip == Enums.SpriteFlip.LEFT:
			velocity.x = -speed
		elif _sprite_flip == Enums.SpriteFlip.RIGHT:
			velocity.x = speed
	elif _state == EnemyState.SHOOTING:
		velocity.x = 0
	
	var facing = Vector2.LEFT
	if _sprite_flip == Enums.SpriteFlip.LEFT:
		facing = Vector2.LEFT
	elif _sprite_flip == Enums.SpriteFlip.RIGHT:
		facing = Vector2.RIGHT

	# Godawful.
	if _player != null:
		var enemy_to_player = _player.position - self.position
		if enemy_to_player.length() < _max_distance:
			var angle = acos(enemy_to_player.normalized().dot(facing))
			if rad_to_deg(angle) < _fov:
				_raycast.target_position = enemy_to_player
				if _raycast.is_colliding() and _raycast.get_collider().is_in_group("player"):
					_state = EnemyState.SHOOTING
				else:
					_state = EnemyState.MOVING
			else:
				_state = EnemyState.MOVING
		else:
			_state = EnemyState.MOVING

	move_and_slide()

func _on_shoot_timer_timeout():
	var new_laser = _laser_tscn.instantiate()
	add_sibling(new_laser)
	
	new_laser.position.y = self.position.y + BULLET_OFFSET_Y
	
	if _sprite_flip == Enums.SpriteFlip.LEFT:
		new_laser.set_direction(Vector2.LEFT)
		new_laser.position.x = self.position.x + BULLET_OFFSET_X
	elif _sprite_flip == Enums.SpriteFlip.RIGHT:
		new_laser.set_direction(Vector2.RIGHT)
		new_laser.position.x = self.position.x - BULLET_OFFSET_X
	
	_sprite.play("attack")

func _on_animated_sprite_2d_animation_looped():
	if _sprite.animation == "attack":
		_sprite.play("default")
