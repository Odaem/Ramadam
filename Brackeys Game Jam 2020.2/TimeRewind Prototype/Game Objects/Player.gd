extends RewindableRigidBody2D

# movement parameters
export var move_force_strength = 0
export var max_move_velocity = 0
var move: float = 0.0

# jumping parameters
export var jump_initial_impulse_strength = 0
export var jump_continued_force_strength = 0
export var jump_margin: float = 0.1
onready var air_time: float = jump_margin
export var jump_continue_time: float = 0.2
onready var jump_time: float = jump_continue_time
var jump_input = false

# collision information
var on_floor = false
var on_ceil = false
var floor_normal = Vector2()
var floor_velocity = Vector2()
var floor_max_angle = 3 * PI/8
var up_vector = Vector2(0, -1)

func _ready():
	pass
	$Rewinder.saved_paths += [
#		"Sprite:animation",
		"Sprite:frame",
#		"Sprite:flip_h",
		":air_time",
		":jump_time",
		":on_floor",
		":on_ceil",
		":move",
	]


func _process(delta):
#	$Container/Label.text = ""
#	$Container/Label.text += "on_floor = " + str(on_floor) + "\n"
#	$Container/Label.text += "jump_input = " + str(jump_input) + "\n"
#	$Container/Label.text += "applied_force = " + str(applied_force) + "\n"
#	$Container/Label.text += "linear_velocity = " + str(linear_velocity) + "\n"
	
	$Sprite.speed_scale = rew.get_playback_speed()
	
	if on_floor:
#		if linear_velocity.dot(up_vector.tangent()) != 0:
		if move != 0:
			$Sprite.animation = "running"
		else:
			$Sprite.animation = "idle"
	else:
		if v_linear_velocity.dot(up_vector) > 0:
			$Sprite.animation = "jumping"
		else:
			$Sprite.animation = "falling"
	
#	if linear_velocity.dot(up_vector.tangent()) != 0:
	if move != 0:
#		$Sprite.flip_h = linear_velocity.dot(up_vector.tangent()) > 0
		$Sprite.flip_h = move < 0

func _physics_process(delta):
	if active:
		move = 0.0
		if Input.is_action_pressed("player_move_left"):
			move -= Input.get_action_strength("player_move_left")
		if Input.is_action_pressed("player_move_right"):
			move += Input.get_action_strength("player_move_right")
		if move != 0.0:
			physics_material_override.friction = 0.0
		else:
			physics_material_override.friction == 1.0
		
		if Input.is_action_just_released("player_jump"):
			jump_input = false
		if Input.is_action_just_pressed("player_jump"):
			jump_input = true
	else:
		pass

#onready var prev_transform = transform
func _active_integrate_forces(state):
	var delta = state.step
	
	var cons = state.get_contact_count()
	on_floor = false
	on_ceil = false
	for i in range(cons):
		var norm = state.get_contact_local_normal(i)
		if abs(norm.angle_to(up_vector)) <= floor_max_angle + 0.001:
			on_floor = true
			floor_normal = norm
			floor_velocity = state.get_contact_collider_velocity_at_position(i)
		if abs(norm.angle_to(-state.total_gravity)) <= PI/4:
			on_ceil = true
	
	
	if on_floor:
		air_time = 0.0
	else:
		air_time += delta
	
	if move != 0:
		if on_floor and jump_time >= jump_continue_time:
			state.linear_velocity = state.linear_velocity.project(floor_normal) + floor_normal.tangent() *(-move * max_move_velocity)
		else:
			state.linear_velocity = state.linear_velocity.project(up_vector) + up_vector.tangent() *(-move * max_move_velocity)
	else:
		if on_floor and jump_time >= jump_continue_time:
			state.linear_velocity = state.linear_velocity.project(floor_normal) + floor_velocity.project(floor_normal.tangent())
		else:
#			var h_vel = state.linear_velocity.dot(up_vector.tangent())
			state.linear_velocity = state.linear_velocity.project(up_vector)
	
	
	if jump_input:
		if jump_time < jump_continue_time:
			state.add_central_force(up_vector * jump_continued_force_strength)
			jump_time += delta
		else:
			if air_time < jump_margin:
#				state.apply_central_impulse(up_vector * jump_initial_impulse_strength)
				state.linear_velocity = state.linear_velocity.project(up_vector.tangent())
				state.linear_velocity += up_vector * jump_initial_impulse_strength
				jump_time = 0.0
			else:
				jump_time = jump_continue_time
				jump_input = false
	else:
		if jump_time < jump_continue_time:
			var fac = (-jump_initial_impulse_strength) * (1 - jump_time / jump_continue_time)
			state.apply_central_impulse(up_vector * fac)
			jump_time = jump_continue_time
	
	
	var acc
	acc = applied_force / mass
	if not on_floor:
		acc += state.total_gravity
	state.linear_velocity += acc * delta
#	state.transform.origin += linear_velocity * state.step
#	._active_integrate_forces(state)
	applied_force = Vector2()
	pass


#func _update_integrate_forces(state):


func activate():
	.activate()
	$Sprite.playing = true


func deactivate():
	.deactivate()
	$Sprite.playing = false


func hit():
	get_node("/root").get_child(0).reload_level()
