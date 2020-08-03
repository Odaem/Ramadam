extends KinematicBody2D
class_name Entity

export var gravity = Vector2(0, 800)
var linear_velocity = Vector2()

var move_direction = Vector2()
export var max_movement_speed: float = 160.0
export var movement_acceleration: float = 3200.0

var do_jump = false
var may_jump = false
export var jump_margin: float = 0.1
export var min_jump_height: float = 18.0
var jump_strength: float = 64.0
var jump_time: float = 0.0
export var max_jump_time: float = 0.2
var air_time: float = 0.0

var saved_keys = [
	":position",
	":linear_velocity",
	":move_direction",
	":do_jump",
	":may_jump",
	":jump_time",
	":air_time",
	"Sprite:animation",
	"Sprite:frame",
	"Sprite:flip_h"
]

export var active: bool = true setget set_active, is_active
func set_active(value: bool):
	if active != value:
		if value:
			activate()
		else:
			deactivate()
		active = value
func is_active():
	return active


func activate():
	collision_layer = 2
	collision_mask = 1
	$Sprite.playing = true

func deactivate():
	collision_layer = 0
	collision_mask = 0
	$Sprite.playing = false


func _ready():
	jump_strength = sqrt(2.0 * min_jump_height * gravity.length())
	pass


func _process(delta):
	if active:
		if move_direction.x != 0:
			$Sprite.flip_h = move_direction.x < 0
		if is_on_floor():
			if move_direction:
				$Sprite.animation = "running"
			else:
				$Sprite.animation = "idle"
		elif linear_velocity.y < 0:
			$Sprite.animation = "jumping"
		else:
			$Sprite.animation = "falling"


func _physics_process(delta):
	if active:
		var speed_multiplier
		var speed_in_move_dir = linear_velocity.dot(move_direction.normalized())
		if move_direction.length_squared() != 0:
			speed_multiplier = min(max((max_movement_speed - speed_in_move_dir), 0), max_movement_speed) / max_movement_speed
			linear_velocity += move_direction * speed_multiplier * movement_acceleration * delta
		else:
	#		var floor_tan = get_floor_normal().rotated(PI/2)
	#		var speed_in_floor_dir = linear_velocity.dot(floor_tan)
			linear_velocity.x -= linear_velocity.x / max_movement_speed * movement_acceleration * delta
			
		
		if is_on_floor():
			may_jump = true
			air_time = 0.0
		else:
			air_time += delta
			if air_time > jump_margin:
				may_jump = false
		
		if is_on_ceiling():
			jump_time = 0.0
		
		if do_jump and may_jump:
			linear_velocity += Vector2(0, -1) * jump_strength - gravity * delta
			may_jump = false
			jump_time = max_jump_time
			jump_time -= delta
		elif do_jump and jump_time > 0.0:
			linear_velocity -= gravity * delta
			jump_time -= delta
		else:
			jump_time = 0.0
			do_jump = false
		
		linear_velocity += gravity * delta
		
		linear_velocity = move_and_slide(linear_velocity, Vector2(0,-1))
