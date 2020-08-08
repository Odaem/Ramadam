extends RewindableRigidBody2D
var dir = Vector2(-1,0)
const SPEED = 500


func _physics_process(delta):
#	var kbd2 = self.move_and_collide(dir * delta * SPEED)
	var getType = self.get_meta("type") #prints rocket
	var ray = $RayCast2D
	if ray.is_colliding():
		var collidedObject = ray.get_collider() #works
#		print(collidedObject)
		if collidedObject != null && "Rocket" in collidedObject.name:
			print("collided with rocket")
			self.queue_free()
			collidedObject.queue_free()
	if position.x > 90 && position.x < 130:
		queue_free()


func _active_integrate_forces(state):
	state.linear_velocity = dir * SPEED
	state.transform.origin += state.linear_velocity * state.step
	transform = state.transform
