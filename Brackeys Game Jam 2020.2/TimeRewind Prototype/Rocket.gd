extends KinematicBody2D
var dir = Vector2(-10,0)
const SPEED = 50

func _physics_process(delta):
	move_and_slide(dir * SPEED)
