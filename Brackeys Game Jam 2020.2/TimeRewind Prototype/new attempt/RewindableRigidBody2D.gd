extends RigidBody2D


var prev_position
var prev_rotation
var v_position
var v_rotation
var v_linear_velocity
var v_angular_velocity

var saved_paths = [
	":v_position",
	":v_rotation",
	"v_linear_velocity",
	"v_angular_velocity"
]

export var active = true setget set_active
func set_active(value: bool):
	if active != value:
		if value:
			activate()
		else:
			deactivate()
		active = value


func _ready():
	assert(has_node("Rewinder") and $Rewinder is Rewinder)
	custom_integrator = true


func activate():
	active = true
	


func deactivate():
	active = false


func _physics_process(delta):
	pass


func _integrate_forces(state):
	if active:
		pass
	else:
		state.linear_velocity = v_linear_velocity * $Rewinder.playback_speed
		state.angular_velocity = v_angular_velocity * $Rewinder.playback_speed


