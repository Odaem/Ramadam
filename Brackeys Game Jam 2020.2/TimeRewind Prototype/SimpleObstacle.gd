extends RigidBody2D

var active: bool = true setget set_active, is_active
var apply_change = false

var saved_keys = [
	":position",
	":rotation",
	":v_linear_velocity",
	":v_angular_velocity"
]

var prev_col_layer: int = 0
var prev_col_mask: int = 0
var prev_mode

#onready var v_position = position
#onready var v_rotation = rotation
onready var v_linear_velocity = linear_velocity
onready var v_angular_velocity = angular_velocity


signal clicked(object)


func set_active(value: bool):
	if active != value:
		if value:
			_activate()
		else:
			_deactivate()
		active = value

func is_active():
	return active


func _activate():
#	collision_layer = prev_col_layer
#	collision_mask = prev_col_mask
#	mode = RigidBody2D.MODE_CHARACTER
	mode = prev_mode
	apply_change = true
	
func _deactivate():
#	prev_col_layer = collision_layer
#	collision_layer = 0
#	prev_col_mask = collision_mask
#	collision_mask = 0
	prev_mode = mode
	mode = RigidBody2D.MODE_KINEMATIC


func _ready():
	if has_node("Rewinder"):
		$Rewinder.saved_keys = saved_keys
	prev_mode = mode


func _integrate_forces(state):
	if not active:
		state.linear_velocity = -v_linear_velocity
		state.angular_velocity = -v_angular_velocity
	elif apply_change:
		state.linear_velocity = v_linear_velocity
		state.angular_velocity = v_angular_velocity
		var trans = Transform2D(rotation, position)
		state.transform = trans
		apply_change = false
	else:
		v_linear_velocity = state.linear_velocity
		v_angular_velocity = state.angular_velocity
#		v_position = state.transform.origin
#		v_rotation = state.transform.get_rotation()


func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("select_object"):
			emit_signal("clicked", self)


func select():
	$Sprite.modulate = Color(0.5,1.0,0.5)

func deselect():
	$Sprite.modulate = Color(1.0,1.0,1.0)
