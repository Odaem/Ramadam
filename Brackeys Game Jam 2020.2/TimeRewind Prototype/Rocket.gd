extends KinematicBody2D
var dir = Vector2(-10,0)
const SPEED = 50

func _physics_process(delta):
	var kbd2 = self.move_and_collide(dir * delta * SPEED)
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
