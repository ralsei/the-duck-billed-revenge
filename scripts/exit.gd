extends Area2D

@export var _sprite: AnimatedSprite2D

func _process(delta):
	if GameState.is_level_over():
		_sprite.visible = true
		_sprite.play("default")
	else:
		_sprite.visible = false

func _on_body_entered(body: Node2D):
	if body.is_in_group("player") and GameState.is_level_over():
		GameState.advance_level()
