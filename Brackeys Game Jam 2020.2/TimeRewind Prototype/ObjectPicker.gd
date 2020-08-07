extends Node2D


var selected: CollisionObject2D


func _ready():
	pass

#
#func _input(event):
#	if selected:
#		var rew = selected.get_node("Rewinder")
#		if event.is_action("pause_object") and Input.is_action_just_pressed("pause_object"):
#			rew.active = not rew.active
#		if event.is_action_pressed("rewind"):
#			rew.rewind_speed = -1
#		elif event.is_action_pressed("forward"):
#			rew.rewind_speed = 1
#		else:
#			rew.rewind_speed = 0


func _process(delta):
		if selected:
			var rew = selected.get_node("Rewinder")
			
			if Input.is_action_just_pressed("pause_object"):
				rew.active = not rew.active
			
			if Input.is_action_just_pressed("rewind"):
				rew.rewind_speed = max(rew.rewind_speed - 1, -4)
			elif Input.is_action_just_pressed("forward"):
				rew.rewind_speed = min(rew.rewind_speed + 1, 4)
			
			$LabelPosition.global_transform.origin = selected.global_transform.origin
			if not rew.active:
				$LabelPosition/Label.text = "x" + str(rew.effective_speed(rew.rewind_speed))
			else:
				$LabelPosition/Label.text = ""
		else:
			$LabelPosition/Label.text = ""


func _unhandled_input(event):
	if event.is_action_pressed("select_object"):
		set_new_target()


func _on_object_clicked(object: CollisionObject2D):
	set_new_target(object)


func set_new_target(target: CollisionObject2D = null):
	if selected:
		if not selected.is_active():
			return
		if selected.has_method("deselect"):
			selected.deselect()
	if target:
		selected = target
		if selected.has_method("select"):
			selected.select()
	else:
		selected = null
