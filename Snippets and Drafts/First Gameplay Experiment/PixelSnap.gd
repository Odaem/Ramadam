extends Sprite

export var snap_to_pixels := true

func _ready():
	pass

func _process(delta):
	if snap_to_pixels:
		var parent_position: Vector2 = get_parent().get_global_transform().get_origin()
		position = parent_position.round() - parent_position
