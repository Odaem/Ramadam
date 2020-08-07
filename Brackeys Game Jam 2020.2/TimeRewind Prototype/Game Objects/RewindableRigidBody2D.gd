extends RigidBody2D
class_name RewindableRigidBody2D

onready var v_transform = transform
onready var v_linear_velocity = linear_velocity
onready var v_angular_velocity = angular_velocity

const saved_paths = [
	":v_transform",
	":v_linear_velocity",
	":v_angular_velocity"
]

export var outline_width: float = 1

onready var active_mode: int = mode

export var active = true setget set_active
var update = false
var selected = false
var hovered = false


func _ready():
	assert(has_node("Rewinder") and $Rewinder is Rewinder)
	$Rewinder.saved_paths = saved_paths
	
	custom_integrator = true
	can_sleep = false
	
	$Rewinder.start_recording()


func _process(delta):
	pass


func _physics_process(delta):
	if not active:
		$Rewinder.step_time()
		$Rewinder.play_frame()
		transform = v_transform


func _integrate_forces(state):
	if active:
		if update:
			state.transform = v_transform
			state.linear_velocity = v_linear_velocity
			state.angular_velocity = v_angular_velocity
			update = false
		_active_integrate_forces(state)
		v_transform = state.transform
		v_linear_velocity = state.linear_velocity
		v_angular_velocity = state.angular_velocity
		$Rewinder.record_frame()
	else:
		var d_pos = v_transform.origin - state.transform.origin
		var d_rot = v_transform.get_rotation() - state.transform.get_rotation()
		state.linear_velocity = d_pos / state.step
		state.angular_velocity = d_rot / state.step
		state.transform = v_transform


func _active_integrate_forces(state: Physics2DDirectBodyState):
	state.integrate_forces()


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
	$Rewinder.start_recording()


func deactivate():
	active = false
	mode = RigidBody2D.MODE_KINEMATIC
	$Rewinder.start_playing()

func set_outline(width: float, color: Color = Color()):
	$Sprite.material.set_shader_param("outline_width", width)
	$Sprite.material.set_shader_param("outline_color", color)

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
