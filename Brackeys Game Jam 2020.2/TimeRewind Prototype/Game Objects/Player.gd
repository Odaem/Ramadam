extends RewindableRigidBody2D


export var move_force_strength = 5


func _ready():
	pass
	$Rewinder.saved_paths += [
		"Sprite:animation",
		"Sprite:frame",
		"Sprite:flip_h",
#		":prev_transform"
	]


func _process(delta):
	pass


func _physics_process(delta):
#	add_central_force(Vector2(20,0))
	pass

#onready var prev_transform = transform
func _active_integrate_forces(state):
	var acc = applied_force / mass + state.total_gravity
	linear_velocity += acc * state.step
	state.transform.origin += linear_velocity * state.step
	applied_force = Vector2()
	pass


func activate():
	.activate()
	$Sprite.playing = true


func deactivate():
	.deactivate()
	$Sprite.playing = false


func _on_body_shape_entered(body_id, body, body_shape, local_shape):
	pass
	get_shape_owners()
	

func _on_body_shape_exited(body_id, body, body_shape, local_shape):
	pass
