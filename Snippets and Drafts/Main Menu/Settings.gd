extends PopupPanel

func _ready():
#	$"../../HBoxContainer/VBoxContainer/VBoxContainer/Button2".connect("opened_settings", self, "_on_settings_opened")
	pass

#func _on_settings_opened():
#	popup()




func _on_Button2_pressed():
	popup()


func _on_TextureButton_pressed():
	hide()
