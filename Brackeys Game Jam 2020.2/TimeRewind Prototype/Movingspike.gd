extends Node2D

const IDLE_DURATION:float = 0.25
export var destination = Vector2.RIGHT * 200
export var general_speed:float = 15.0 #tiles per second 
export var start_offset = Vector2(0,0)
export var end_offset = Vector2(0,0)


onready var spike = $spike
onready var tween = $MoveTween


func _ready():
	move_platform()
	
func move_platform():
	var duration = destination.length()/float(general_speed * 16)
	tween.interpolate_property(spike, "position", Vector2.ZERO + start_offset, destination+end_offset, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(spike, "position", destination + end_offset, Vector2.ZERO + start_offset, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration)
	tween.start()
