extends Camera2D

@export var _player: CharacterBody2D
@export var _bounds_map: TileMap

func _ready():
	var map_limits = _bounds_map.get_used_rect()
	var map_cellsize = _bounds_map.cell_quadrant_size
	
	# offset by 1 to account for the bounding box tile size
	self.limit_left = (map_limits.position.x + 1) * map_cellsize
	self.limit_right = (map_limits.end.x - 1) * map_cellsize
	self.limit_top = (map_limits.position.y + 1) * map_cellsize
	self.limit_bottom = (map_limits.end.y - 1) * map_cellsize

func _process(delta):
	if _player != null:
		self.position = _player.position
