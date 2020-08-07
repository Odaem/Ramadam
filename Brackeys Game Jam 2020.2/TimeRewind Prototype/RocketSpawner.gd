extends Node2D

var rocket  = preload("res://Rocket.tscn")

func _on_respawnTimer_timeout():
	var yLoc = rand_range(190,350)
	var xLoc = 1600
	var r = rocket.instance()
	add_child(r)
	r.position = Vector2(xLoc,yLoc)
	
func _physics_process(delta):
	pass
	

