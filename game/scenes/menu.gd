extends Control

func _ready() -> void:
	%PlayButton.grab_focus()
	%PlayButton.pressed.connect(STransitions.change_scene_with_transition.bind("uid://bqkcvdot8ygo3"))
	#%SettingsButton.pressed.connect(add_child.bind(preload("uid://dp42fom7cc3n0").instantiate()))
	%QuitButton.pressed.connect(get_tree().quit)
	%CreditsButton.pressed.connect(STransitions.change_scene_with_transition.bind("uid://bq0gelfcjnqvg"))
