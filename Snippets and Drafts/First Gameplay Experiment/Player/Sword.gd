extends RigidBody2D


export var speed: float = 400
export var rotation_speed: float = 2000
export var move_point := Vector2(0, 0)
export var attack: int = 3

enum STATE {IDLE, DASHING}
var state: int = STATE.IDLE

var dash_timer:float = 0
var dash_cooldown:float = 0.5


func _ready():
	get_viewport().warp_mouse(get_global_transform_with_canvas().get_origin())


func _integrate_forces(phys_state):
	match state:
		STATE.IDLE:
			var relative_mouse_pos = get_global_mouse_position() - get_global_transform().get_origin()
			
			phys_state.apply_torque_impulse(get_local_mouse_position().angle() / PI * rotation_speed)
			
			if Input.is_action_just_pressed("sword_dash"):
#				var viewport_size = get_viewport_rect().size
#				phys_state.apply_central_impulse(relative_mouse_pos.normalized() * speed)
				phys_state.apply_central_impulse(Vector2.RIGHT.rotated(rotation) * speed)
				state = STATE.DASHING
			
			if get_local_mouse_position().length_squared() > 24 * 24:
				phys_state.apply_central_impulse(Vector2.RIGHT.rotated(rotation) * speed * phys_state.step)
			
		STATE.DASHING:
			dash_timer -= phys_state.step
			if dash_timer <= 0:
				state = STATE.IDLE
				dash_timer = dash_cooldown


func _on_blade_hit(body: PhysicsBody2D):
	if body.is_in_group("Enemies"):
		if body.has_method("get_hit"):
			print("hit")
			body.get_hit(attack, (body.position - position).normalized())
