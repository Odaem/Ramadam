extends RigidBody2D
class_name RewindableRigidBody2D

#export(NodePath) var rewinder_path
var rew: Rewinder

onready var v_transform = transform
onready var v_linear_velocity = linear_velocity
onready var v_angular_velocity = angular_velocity

const saved_paths = [
	":v_transform",
	":v_linear_velocity",
	":v_angular_velocity",
	":applied_force",
	":applied_torque"
]

export var outline_width: float = 1

onready var active_mode: int = mode

export var active = true setget set_active
var update = false
var selected = false
var hovered = false


func _ready():
	for child in get_children():
		if child is Rewinder:
			rew = child
			break
	
	assert(rew and rew is Rewinder)
	rew.saved_paths += saved_paths
	
	custom_integrator = true
	can_sleep = false


func _process(delta):
	pass


func _physics_process(delta):
	pass


func _integrate_forces(state):
	if active:
		if update:
			_update_integrate_forces(state)
			update = false
		_active_integrate_forces(state)
		v_transform = state.transform
		v_linear_velocity = state.linear_velocity
		v_angular_velocity = state.angular_velocity
		rew.record_frame()
	else:
		rew.play_next_frame()
		var d_pos = v_transform.origin - state.transform.origin
		var d_rot = v_transform.get_rotation() - state.transform.get_rotation()
		state.linear_velocity = d_pos / state.step
		state.angular_velocity = d_rot / state.step
		state.transform = v_transform
		transform = v_transform


func _active_integrate_forces(state: Physics2DDirectBodyState):
	state.integrate_forces()


func _update_integrate_forces(state: Physics2DDirectBodyState):
	state.transform = v_transform
	state.linear_velocity = v_linear_velocity
	state.angular_velocity = v_angular_velocity
#	state.add_central_force(applied_force)
#	state.add_torque(applied_torque)


func set_active(value: bool):
	if active != value:
		if value:
			activate()
		else:
			deactivate()
		active = value


func activate():
	active = true
	update = true
	mode = active_mode


func deactivate():
	active = false
	mode = RigidBody2D.MODE_KINEMATIC


func set_outline(width: float, color: Color = Color()):
	material.set_shader_param("outline_width", width)
	material.set_shader_param("outline_color", color)

func select():
	selected = true
	set_outline(outline_width, Color(0,1,0))

func deselect():
	selected = false
	set_outline(0)

func hover():
	hovered = true
	if not selected:
		set_outline(outline_width, Color(1,1,1))

func dehover():
	hovered = false
	if not selected:
		set_outline(0)
