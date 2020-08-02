extends Entity
class_name Player

export(NodePath) var SpawnPosition

func _ready():
	._ready()


func _process(delta):
	move_direction = Vector2()
	
	move_direction.x = -Input.get_action_strength("player_move_left") + Input.get_action_strength("player_move_right")
	
	if move_direction.length_squared() != 0:
		move_direction = move_direction.normalized()
	
	if Input.is_action_pressed("player_jump"):
		do_jump = true
	else:
		do_jump = false
		
	._process(delta)
		
#func _physics_process(delta):
#	._physics_process(delta)


func respawn():
	var spawn_node = get_node(SpawnPosition)
	if spawn_node:
		position = spawn_node.position
		linear_velocity = Vector2()
