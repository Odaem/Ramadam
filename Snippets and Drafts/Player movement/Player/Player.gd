extends KinematicBody2D

var dir = Vector2()
var speed = 100
var velocity = Vector2()

var gravity = 200

func _ready():
	queue_free()

func _physics_process(delta):
	dir = Vector2()
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	velocity *= pow(0.99, delta)
	velocity += dir.normalized() * speed * delta
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2(0,-1))
