extends CharacterBody2D

@export var _weapon: PackedScene
@export var _sprite: AnimatedSprite2D
@export var _end_card: PackedScene
@export var _camera: Camera2D

enum PlayerState { IDLE, MOVING, JUMPING, DYING }

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const WEAPON_OFFSET_X = 10.0
const WEAPON_OFFSET_Y = 7.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var _sprite_flip := Enums.SpriteFlip.RIGHT
var _player_state := PlayerState.IDLE

func _is_dying():
	return _player_state == PlayerState.DYING

func _process(delta):
	if not _is_dying():
		if Input.is_action_just_pressed("attack"):
			var wp = _weapon.instantiate()
			add_child(wp)
			wp.position.y = WEAPON_OFFSET_Y
			if _sprite_flip == Enums.SpriteFlip.LEFT:
				wp.position.x = -WEAPON_OFFSET_X
			else:
				wp.position.x = WEAPON_OFFSET_X
			wp.set_direction(_sprite_flip)
		
	if self._player_state == PlayerState.IDLE:
		_sprite.play("default")
	elif self._player_state == PlayerState.MOVING:
		_sprite.play("run")
	elif self._player_state == PlayerState.JUMPING:
		_sprite.play("jump")
	elif self._player_state == PlayerState.DYING:
		_sprite.play("die")
	
	if self._sprite_flip == Enums.SpriteFlip.RIGHT:
		_sprite.flip_h = false
	else:
		_sprite.flip_h = true

func _physics_process(delta):
	if not _is_dying():
		if not is_on_floor():
			velocity.y += gravity * delta

		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			if is_on_floor():
				self._player_state = PlayerState.MOVING

			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 10)
			GameState.player_abs_velocity = abs(velocity.x)
			
			if direction <= 0:
				self._sprite_flip = Enums.SpriteFlip.LEFT
			else:
				self._sprite_flip = Enums.SpriteFlip.RIGHT
		else:
			if is_on_floor():
				self._player_state = PlayerState.IDLE
			
			velocity.x = move_toward(velocity.x, 0, SPEED / 10)
			GameState.player_abs_velocity = abs(velocity.x)
			
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			self._player_state = PlayerState.JUMPING
			velocity.y = JUMP_VELOCITY

		move_and_slide()

func die():
	self._player_state = PlayerState.DYING

func _on_animated_sprite_2d_animation_looped():
	if _sprite.animation == "die":
		var ec = _end_card.instantiate()
		ec.visible = true
		
		var cam_pos = _camera.get_screen_center_position()
		ec.position.x = cam_pos.x - 110
		ec.position.y = cam_pos.y - 25
		
		add_sibling(ec)
		self.queue_free()
