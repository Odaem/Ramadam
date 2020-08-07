extends KinematicBody2D

const direction_up = Vector2(0,-1)
const gravity:float = 15.0 
const movement_speed = 200
var move = Vector2(0,0) 

#is_action_pressed
#is_action_just_pressed
func _physics_process(delta):
	
	# can run with value 10 but not var gravity
		# resolved: by specifying type of var gravity 
	move.y  += gravity 
	print(move)
	if Input.is_action_pressed("ui_right"):
		move.x = movement_speed 
	elif Input.is_action_pressed("ui_left"):
		move.x = -movement_speed
	else: 
		# if neither left or right is pressed then it stays still 
		move.x = 0 
	
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			move.y = -300
		else:
			move.y = 0 
	
	# move_and_slide takes velocity as vector but also up direction which indicates
	# where the floor is.
	# Giving direction_up into move_and_slide enables jump
	move_and_slide(move, direction_up)
	
	
