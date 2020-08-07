extends Node
class_name Rewinder


var time_data = []

export var saved_paths = []
# this variable should be set by parent or in editor
# it contains the paths to the properties to be saved, as strings

var time: int = 0
export var playback_speed: int = 0
export var recording = false
export var playing = false

func _ready():
#	process_priority = get_parent().process_priority - 1
	pass


func _physics_process(delta):
#	if recording:
#		record_frame()
#		time = time_data.size()
#	elif playing:
#		step_time()
#		play_frame()
	pass


func start_recording():
	recording = true
	playing = false
	if time < time_data.size() - 1:
		time_data.resize(time + 1)


func start_playing():
	playing = true
	recording = false


func disable():
	recording = false
	playing = false


#var rec_count = 0
func record_frame(at_time: int = time_data.size()):
	var frame = {}
	for key in saved_paths:
		var node = get_parent().get_node(key)
		frame[key] = node.get(NodePath(key).get_concatenated_subnames())
#	if rec_count % 120 == 0:
#		print(at_time, "\n", frame)
	set_frame(frame, at_time)
	time = at_time


#var play_count = 0
func play_frame(at_time: int = time):
	if at_time < 0:
		return
	var frame = get_frame(at_time)
#	if play_count % 120 == 0:
#		print(at_time, "\n", frame)
	for key in saved_paths:
		var node = get_parent().get_node(key)
		node.set(NodePath(key).get_concatenated_subnames(), frame[key])


func get_frame(at_time: int = time):
	at_time = min(max(at_time, 0), max(time_data.size() - 1, 0))
	return bytes2var(time_data[at_time], true)
#	return time_data[at_time]


func set_frame(frame: Dictionary, at_time: int = time):
	at_time = min(max(at_time, 0), time_data.size())
	if at_time == time_data.size():
		time_data.insert(at_time, var2bytes(frame, true))
#		time_data.insert(at_time, frame)
	else:
		time_data[at_time] = var2bytes(frame, true)
#		time_data[at_time] = frame


#func insert_frame(frame: Dictionary, at_time: int = time):
#	at_time = min(max(at_time, 0), time_data.size())
#	time_data.insert(at_time, var2bytes(frame, true))


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


func step_time():
	time = min(max(time + playback_speed, 0), max(time_data.size() - 1, 0))


func calc_playback_speed_from_level(level: int):
	return sign(level) * pow(2.0, abs(level) - 1)


func calc_level_from_playback_speed(speed: int):
	if speed == 0:
		return 0
	return sign(speed) * (log(abs(speed)) / log(2.0) + 1)


func set_playback_speed_from_level(level: int):
	playback_speed = calc_playback_speed_from_level(level)
