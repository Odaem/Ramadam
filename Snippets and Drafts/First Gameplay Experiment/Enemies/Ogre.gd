extends KinematicBody2D

export var target: NodePath
export var speed: int = 20

func _ready():
	$AnimationTree.active = true

func _process(delta):
	var walk_dir := Vector2()
	if target:
		var t = get_node(target)
		if t is Node2D:
			walk_dir = (t.get_transform().get_origin() - position).normalized()
			
	if walk_dir != Vector2.ZERO:
		move_and_slide(walk_dir * speed)
		


func get_hit():
	queue_free()