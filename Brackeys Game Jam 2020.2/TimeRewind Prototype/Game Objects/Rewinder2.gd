extends Node
class_name Rewinder


var time_data = PoolByteArray()
var frame_indeces = PoolIntArray()
#var frame_size: int
var full_frame_freq: int = 120

# @saved_paths should be set by parent or in editor
# it contains the paths to the properties to be saved, as strings
export var saved_paths = []

var time_cursor: int = -1
export var playback_speed: int = 0
var max_time setget , get_max_time


var compression_mode = File.COMPRESSION_DEFLATE


func _ready():
	pass


func _physics_process(delta):
	pass


# saves the current state of all tracked values to the frame AFTER @at_time
func record_frame(at_time: int = time_cursor):
	at_time = at_time + 1
	assert(0 <= at_time, at_time <= frame_indeces.size())
	
	set_playback_speed(1) # time is currently going real-time
	
	var frame
	if at_time % full_frame_freq == 0:
		frame = _record_full_frame()
	else:
		frame = _record_part_frame(at_time)
	
	if at_time < frame_indeces.size():
		time_data.resize(frame_indeces[at_time])
		frame_indeces.resize(at_time + 1)
	else:
		frame_indeces.append(time_data.size())
	
	if frame.size() > 0:
		var bytes = var2bytes(frame, true)
		
		var compressed = bytes.compress(compression_mode)
		
		if frame.size() > 0:
			time_data.append_array(var2bytes(bytes.size()))
			if compressed.size() < bytes.size():
				time_data.append_array(compressed)
			else:
				time_data.append_array(bytes)
	
	time_cursor = at_time


# returns the current state of all tracked values
func _record_full_frame():
	var frame = {}
	for path in saved_paths:
		frame[path] = _get_parent_property(path)
	return frame


func _record_part_frame(at_time: int):
	var frame = {}
	var full = get_last_full_frame(at_time)
	for path in saved_paths:
		var real = _get_parent_property(path)
		if full[path] != real:
			frame[path] = real
	return frame


# get frame information of frame @at_frame
func _get_frame(at_time: int = time_cursor):
	assert(0 <= at_time, at_time < frame_indeces.size())
	
	var frame = {}
	
	var i = frame_indeces[at_time]
	var frame_size = get_frame_size(at_time)
	
	if frame_size > 0:
		var size = bytes2var(time_data.subarray(i, i + 8 - 1))
		var bytes = time_data.subarray(i + 8, i + frame_size - 1)
		
		if bytes.size() < size:
			bytes = bytes.decompress(size, compression_mode)
		
		frame = bytes2var(bytes)
	
	return frame


func get_last_full_frame(at_time: int = time_cursor):
	return _get_frame(at_time / full_frame_freq * full_frame_freq)


func get_frame(at_time: int = time_cursor):
	var full = get_last_full_frame(at_time)
	
	if at_time % full_frame_freq != 0:
		var part = _get_frame(at_time)
		for key in part:
			full[key] = part[key]
	
	return full


# gets the storage size of frame @at_time
func get_frame_size(at_time: int):
	assert(0 <= at_time, at_time < frame_indeces.size())
	if at_time == frame_indeces.size() - 1:
		return time_data.size() - frame_indeces[at_time]
	else:
		return frame_indeces[at_time + 1] - frame_indeces[at_time]


# takes the values stored for frame @at_time and applies them to the real
# node's properties
func play_frame(at_time: int = time_cursor):
	assert(0 <= at_time, at_time < frame_indeces.size())
	var frame = get_frame(at_time)
#	if play_count % 120 == 0:
#		print(at_time, "\n", frame)
	for key in saved_paths:
		_set_parent_property(key, frame[key])


# advances the time_cursor by playback_time and plays the frame
func play_next_frame():
	step_time()
	play_frame()


# get the stored value of @path at time @at_time
func get_property(path: String, at_time: int = time_cursor):
	return get_frame(at_time)[path]


func _get_parent_property(path: String):
	return get_parent().get_node(path).get(NodePath(path).get_concatenated_subnames())


func _set_parent_property(path: String, value):
	get_parent().get_node(path).set(NodePath(path).get_concatenated_subnames(), value)

## set the stored value of @path at time @at_time
#func set_property(path: String, value, at_time: int = time_cursor):
#	var frame = get_frame(at_time)
#	frame[path] = value
#	set_frame(frame, at_time)


# get playback speed
func get_playback_speed():
	return playback_speed


# set playback speed directly
func set_playback_speed(value: int):
	playback_speed = value


# move the time_cursor by playback_speed
func step_time():
	if playback_speed < 0 and time_cursor == 0 or playback_speed > 0 and time_cursor == get_max_time():
		playback_speed = 0
	if playback_speed != 0:
		time_cursor = min(max(time_cursor + playback_speed, 0), max(frame_indeces.size() - 1, 0))


func get_max_time():
	return frame_indeces.size() - 1


func level2playback_speed(level: int):
	return sign(level) * pow(2.0, abs(level) - 1)


func playback_speed2level(speed: int):
	if speed == 0:
		return 0
	return sign(speed) * (log(abs(speed)) / log(2.0) + 1)


func set_playback_speed_from_level(level: int):
	playback_speed = level2playback_speed(level)
