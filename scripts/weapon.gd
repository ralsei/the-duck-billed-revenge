extends Area2D

@export var _lifetime: Timer

var _sprite_flip := Enums.SpriteFlip.RIGHT

func set_direction(dir: Enums.SpriteFlip):
	_sprite_flip = dir
	if _sprite_flip == Enums.SpriteFlip.LEFT:
		self.rotation_degrees = 180
	elif _sprite_flip == Enums.SpriteFlip.RIGHT:
		self.rotation_degrees = 0

func _process(delta):
	var t = _get_lifetime_pct()
	var rotate_by = lerp(-PI/4, PI/4, t)
	self.rotate(rotate_by)

func _get_lifetime_pct():
	var total_time := _lifetime.wait_time
	var time_left := _lifetime.time_left
	return (total_time - time_left) / total_time

func _on_area_entered(area):
	if area.is_in_group("bullet"):
		area.parry()

func _on_body_entered(body: Node2D):
	if body.is_in_group("enemy"):
		body.queue_free()

func _on_lifetime_timeout():
	self.queue_free()
