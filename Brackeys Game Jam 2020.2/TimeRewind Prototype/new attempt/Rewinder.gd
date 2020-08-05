extends Node
class_name Rewinder


var time_data = []

export var saved_paths = []
# this variable should be set by parent or in editor
# it contains the paths to the properties to be saved, as strings

var time: int = -1
export var playback_speed: int = 1
export var recording = true
export var playing = false


func _ready():
	pass


func _physics_process(delta):
	if recording:
		record_frame()
		time = time_data.size()
	elif playing:
		time = min(max(time + playback_speed, 0), time_data.size() - 1)


func record_frame(at_time: int = time_data.size()):
	var frame = {}
	for key in saved_paths:
		var node = get_parent().get_node(key)
		frame[key] = node.get(NodePath(key).get_concatenated_subnames())
	insert_frame(frame, at_time)


func play_frame(at_time: int = time):
	var frame = get_frame(at_time)
	for key in saved_paths:
		var node = get_parent().get_node(key)
		node.set(NodePath(key).get_concatenated_subnames(), frame[key])


func get_frame(at_time: int = time):
	return bytes2var(time_data[at_time], true)


func set_frame(frame: Dictionary, at_time: int = time):
	time_data[at_time] = var2bytes(frame, true)


func insert_frame(frame: Dictionary, at_time: int = time):
	time_data.insert(at_time, var2bytes(frame, true))


func get_property(path: String, at_time: int = time):
	return get_frame(at_time)[path]


func set_property(path: String, value, at_time: int = time):
	var frame = get_frame(at_time)
	frame[path] = value
	set_frame(frame, at_time)


func get_playback_speed():
	return playback_speed


func set_playback_speed(value: int):
	playback_speed = value


func calc_playback_speed_from_level(level: int):
	return sign(level) * pow(2.0, abs(level) - 1)


func set_playback_speed_from_level(level: int):
	playback_speed = calc_playback_speed_from_level(level)
