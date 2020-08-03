extends Node
#class_name Rewindable


export var saved_keys = []
var save_data = [{}]
var timeline_index = -1
var max_time = 0
var active: bool = true # setget set_active, is_active
#
#func set_active(value: bool):
#	if active != value:
#		active = value
#		if active:
#			activate()
#		else:
#			deactivate()
#
#func is_active():
#	return active


func activate():
	max_time = timeline_index + 1
	save_data.resize(max_time)

func deactivate():
	pass


func _ready():
	if get_parent().saved_keys:
		saved_keys = get_parent().saved_keys


func _process(delta):
	#print(get_parent().get_node(saved_keys[0]).get(saved_keys[0].get_concatenated_subnames()))
	pass


func _physics_process(delta):
	if Input.is_action_just_released("ui_down"):
		active = !active
		if active:
			activate()
		else:
			deactivate()
	
	if active:
		get_parent().active = true
		timeline_index += 1
		max_time += 1
		if save_data.size() < max_time:
			save_data.insert(timeline_index, {})
		for key in saved_keys:
			save_data[timeline_index][key] = get_parent().get_node(key).get(NodePath(key).get_concatenated_subnames())
	else:
		get_parent().active = false
		if Input.is_action_pressed("ui_left"):
			timeline_index = max(timeline_index - 1, 0)
		if Input.is_action_pressed("ui_right"):
			timeline_index = min(timeline_index + 1, max_time - 1)
		for key in saved_keys:
			get_parent().get_node(key).set(NodePath(key).get_concatenated_subnames(), save_data[timeline_index][key])
