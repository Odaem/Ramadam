extends Node

export var scene_paths = [
	"res://new_scenes/ObstacleOne.tscn",
	"res://new_scenes/ObstacleTwo.tscn",
	"res://new_scenes/ObstacleThree.tscn",
]

var current_level: int = 0
var level: Node

func _ready():
	load_level(scene_paths[0])


func _process(delta):
	if Input.is_key_pressed(KEY_R):
		reload_level()


func next_level():
	level.queue_free()
	current_level += 1
	if current_level < scene_paths.size():
		load_level(scene_paths[current_level])
	else:
		win()


func load_level(level_path: String):
	level = load(level_path).instance()
	$Level.add_child(level)
#	level = get_child(get_child_count() - 1)


func reload_level():
	level.queue_free()
	load_level(scene_paths[current_level])


func win():
	level.queue_free()
	$CenterContainer.show()
