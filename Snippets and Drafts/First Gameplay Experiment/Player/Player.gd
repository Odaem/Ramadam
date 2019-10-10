extends KinematicBody2D

export var speed: float = 50

var facing := Vector2(1, 0)

onready var playback = $AnimationTree.get("parameters/playback")

func _ready():
	$AnimationTree.active = true

# warning-ignore:unused_argument
func _process(delta):
	# get input from user
	var move_vector := Vector2.ZERO
	var moved := false
	if Input.is_action_pressed("move_down"):
		move_vector.y += Input.get_action_strength("move_down")
		moved = true
	if Input.is_action_pressed("move_left"):
		move_vector.x -= Input.get_action_strength("move_left")
		moved = true
	if Input.is_action_pressed("move_right"):
		move_vector.x += Input.get_action_strength("move_right")
		moved = true
	if Input.is_action_pressed("move_up"):
		move_vector.y -= Input.get_action_strength("move_up")
		moved = true
	
	# convert input to usable data
	move_vector = move_vector.clamped(1)
	# update the facing direction
	if move_vector != Vector2.ZERO:
		facing = move_vector.normalized()
	
	# set cameraposition relative to mouse
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport_rect().size
	var circle_diameter = min(viewport_size.x, viewport_size.y)
	$CameraPosition.position = ((mouse_pos * 2 - viewport_size) / circle_diameter).clamped(1) * 4 * 16
	
	# do actions depending on if player should move
	if moved:
		# update the sprite to face the right way
		if facing.x > 0:
			$Sprite.flip_h = false
		elif facing.x < 0:
			$Sprite.flip_h = true
		
		# do not snap to pixels while moving
		$Sprite.snap_to_pixels = false
		
		# change animation to apropriate one
		if playback.get_current_node() != "Running":
			playback.travel("Running")
		
		# move according to move_vector
		move_and_slide(move_vector * speed)
	else:
		# change animation to apropriate one
		if playback.get_current_node() != "Idle":
			playback.travel("Idle")
		
		#snap to pixels while standing still
		$Sprite.snap_to_pixels = true
	
	
	
	$Debug/move_dir.set_point_position(1, facing * 15)
	$Debug/move_dir.update()
	

