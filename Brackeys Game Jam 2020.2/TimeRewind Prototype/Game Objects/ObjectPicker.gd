extends Node

var hover_objects = []
var hover: CollisionObject2D
var selected: CollisionObject2D
export(NodePath) var default_selected

var playback_level = 0
var max_playback_level = 6


func _ready():
	default_selected = get_node(default_selected)
	if default_selected:
		default_selected.connect("ready", self, "on_default_ready")


func on_default_ready():
	select(default_selected)
	


func _process(delta):
	if hover_objects.size() > 0:
		var new_hover
		if hover_objects.size() == 1:
			new_hover = hover_objects[0]
		else:
			var dist = INF
			for object in hover_objects:
				if object is CollisionObject2D:
					var new_dist = object.global_transform.origin.distance_to($Selector.global_transform.origin)
					if new_dist < dist:
						new_hover = object
						dist = new_dist
		if not hover == new_hover:
			if hover and hover.has_method("dehover"):
				hover.dehover()
			if new_hover.has_method("hover"):
				new_hover.hover()
			hover = new_hover
	elif hover:
		if hover.has_method("dehover") and hover:
			hover.dehover()
		hover = null
	
	$Label.text = "hover: " + str(hover) + "\nselected: " + str(selected)
	
	if selected:
		if not selected.active:
			playback_level = selected.rew.playback_speed2level(selected.rew.get_playback_speed())
		
		if not selected.active and selected.rew.playback_speed != 0:
			$SpeedDisplayPos.show()
			$SpeedDisplayPos.position = selected.position
			$SpeedDisplayPos/Label.text = "x" + str(selected.rew.playback_speed)
		else:
			$SpeedDisplayPos.hide()
		
		if not selected.active:
			$CenterContainer/ProgressBar.show()
			$CenterContainer/ProgressBar.max_value = selected.rew.max_time
			$CenterContainer/ProgressBar.value = selected.rew.time_cursor
		else:
			$CenterContainer/ProgressBar.hide()
	else:
		$SpeedDisplayPos.hide()
		$CenterContainer/ProgressBar.hide()


func _input(event):
	if event.is_action("select_object") and Input.is_action_just_pressed("select_object"):
#		if not(selected and not selected.active):
			if hover:
				if hover != selected:
					select()
				else:
					if not(default_selected and selected == default_selected):
						deselect()
			else:
				deselect()
	elif selected:
		var rew = selected.get_node("Rewinder")
		
		if event.is_action("pause_object") and Input.is_action_just_pressed("pause_object"):
			if not selected.active and rew.playback_speed != 0:
				set_playback_level(rew, 0)
			else:
				selected.active = not selected.active
				set_playback_level(rew, 0)
		
		elif event.is_action("rewind") and Input.is_action_just_pressed("rewind"):
			if selected.active:
				selected.active = false
				set_playback_level(rew, -1)
			else:
				set_playback_level(rew, playback_level - 1)
		
		elif event.is_action("forward") and Input.is_action_just_pressed("forward"):
			if not selected.active:
				set_playback_level(rew, playback_level + 1)


func set_playback_level(rewinder: Rewinder, level: int = 0):
	playback_level = min(max(level, -max_playback_level), max_playback_level)
	rewinder.set_playback_speed_from_level(playback_level)


func select(obj = hover):
	if obj != selected:
		if selected:
			_deselect(selected)
		selected = obj
		if selected:
			_select(selected)
			playback_level = selected.rew.playback_speed2level(selected.rew.playback_speed)

func deselect():
	if selected != default_selected:
		if default_selected:
			select(default_selected)
		else:
			_deselect(selected)
			selected = null

func _select(obj):
	if obj.has_method("select"):
		obj.select()

func _deselect(obj):
	if obj.has_method("deselect"):
		obj.deselect()


func _on_Selector_body_entered(body):
	hover_objects.append(body)


func _on_Selector_body_exited(body):
	var i = hover_objects.find(body)
	if i >= 0:
		hover_objects.remove(i)
