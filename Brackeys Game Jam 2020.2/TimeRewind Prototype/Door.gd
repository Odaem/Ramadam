extends Area2D


func _ready():
	pass


func _on_body_entered(body):
	get_node("/root").get_child(0).next_level()
