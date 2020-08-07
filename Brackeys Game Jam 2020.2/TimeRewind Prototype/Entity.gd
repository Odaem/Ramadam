extends KinematicBody2D
class_name Entity

export var gravity = Vector2(0, 320)
onready var prev_position = position
var linear_velocity = Vector2()

var move_direction = Vector2()
export var movement_speed: float = 160.0

var do_jump = false
var may_jump = false
export var jump_margin: float = 0.1
export var jump_height: float = 64.0
var jump_strength: float = 64.0
var air_time: float = 0.0


func _ready():
	jump_strength = sqrt(2.0 * jump_height * gravity.length())
	pass


func _process(delta):
	if move_direction.x != 0:
		$Sprite.flip_h = move_direction.x < 0


func _physics_process(delta):
	var speed_multiplier
	var speed_in_move_dir = linear_velocity.dot(move_direction.normalized())
	if move_direction.length_squared() != 0:
		speed_multiplier = min(max(movement_speed - speed_in_move_dir, 0), movement_speed)
		linear_velocity += move_direction * speed_multiplier
	else:
		linear_velocity.x *= pow(0.001, delta)
	
	if is_on_floor():
		may_jump = true
		air_time = 0.0
	else:
		air_time += delta
		if air_time > jump_margin:
			may_jump = false
	
	if do_jump and may_jump:
		linear_velocity += Vector2(0, -1) * jump_strength - gravity * delta
		may_jump = false
	
	linear_velocity += gravity * delta
	
	linear_velocity = move_and_slide(linear_velocity, Vector2(0,-1), true, 4, PI/4, false)
