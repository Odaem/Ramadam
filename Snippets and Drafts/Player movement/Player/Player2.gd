extends RigidBody2D

export(float) var acceleration: float = 1000
export(float) var max_speed: float = 300
export(float) var jump_height: float = 100
export(int) var jumps: int = 1

var on_floor := false
var floor_timer_max: float = 0.2
var floor_timer: float = 0
var floor_normal := Vector2(0, -1)
var current_floor_normal := Vector2()
var floor_max_angle: float = 45
const FLOOR_ANGLE_THRESHOLD := 0.01
var jump_vel: float
var jumps_left: int = 1
var just_jumped := false
var gravity: float = 600


func _ready():
	ProjectSettings.set_setting("physics/2d/default_gravity", gravity)
	jump_vel = sqrt(2 * gravity * jump_height)


func _integrate_forces(state: Physics2DDirectBodyState):
	floor_timer += state.step
	if !just_jumped:
		for i in range(0, state.get_contact_count()):
			var normal: Vector2 = state.get_contact_local_normal(i)
			if abs(normal.angle_to(floor_normal)) <= deg2rad(floor_max_angle) + FLOOR_ANGLE_THRESHOLD:
				current_floor_normal = normal
				floor_timer = 0
				break
	
	if floor_timer < floor_timer_max:
		jumps_left = jumps
		on_floor = true
	else:
		if on_floor == true:
			jumps_left -= 1
			on_floor = false
	
	just_jumped = false
	
	var h_dir: int = 0
	if Input.is_action_pressed("ui_right"):
		h_dir += 1
	if Input.is_action_pressed("ui_left"):
		h_dir -= 1
	if Input.is_action_just_pressed("ui_up") && _may_jump():
		jump(state)
		just_jumped = true
		
	
	if on_floor && h_dir != sign(state.linear_velocity.x):
		physics_material_override.friction = 1
	else:
		physics_material_override.friction = 0
	
	if on_floor:
		applied_force = Vector2(h_dir * acceleration, 0).rotated(current_floor_normal.angle() + PI / 2)
	else:
		applied_force = Vector2(h_dir * acceleration, 0)
	state.linear_velocity.x *= max_speed / (max_speed + acceleration * state.step)


func jump(state: Physics2DDirectBodyState):
	state.linear_velocity.y = -jump_vel
	jumps_left -= 1
	floor_timer = floor_timer_max


func _may_jump() -> bool:
	return jumps_left > 0

