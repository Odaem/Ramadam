extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body: PhysicsBody2D):
	print("collision")
	if body.is_in_group("Enemies"):
		print("	is enemy")
		body.get_hit()