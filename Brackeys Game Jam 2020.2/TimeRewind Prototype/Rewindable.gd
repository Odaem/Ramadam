extends Node
#class_name Rewindable


export var active: bool = true setget set_active, is_active
export var saved_keys = []
var save_data = [{}]
var timeline_index = -1
var max_time = 0
export var rewind_speed: int = -1


func set_active(value: bool):
	if active != value:
		if value:
			_activate()
		else:
			_deactivate()
		active = value

func is_active():
	return active


func _activate():
	get_parent().set_active(true)
	max_time = timeline_index + 1
	save_data.resize(max_time)

func _deactivate():
	get_parent().set_active(false)
	rewind_speed = -1


func _ready():
	pass


func _process(delta):
	#print(get_parent().get_node(saved_keys[0]).get(saved_keys[0].get_concatenated_subnames()))
	pass


func _physics_process(delta):
	if active:
		timeline_index += 1
		max_time += 1
		if save_data.size() < max_time:
			save_data.insert(timeline_index, {})
		for key in saved_keys:
			save_data[timeline_index][key] = get_parent().get_node(key).get(NodePath(key).get_concatenated_subnames())
	else:
		timeline_index = min(max(timeline_index + sign(rewind_speed) * pow(2.0, abs(rewind_speed) - 1), 0), max_time - 1)
		for key in saved_keys:
			get_parent().get_node(key).set(NodePath(key).get_concatenated_subnames(), save_data[timeline_index][key])


func effective_speed(speed_level: int):
	return sign(speed_level) * pow(2.0, abs(speed_level) - 1)
