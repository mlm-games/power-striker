@icon("res://editor-icons/component.svg")
class_name AudioComponent extends Node


func play_impact_audio():
	AudioM.play_sound_varied(preload("res://assets/sound/sfx/Wooden Box.wav"), 0.7, -10)
	AudioM.play_sound_varied(preload("res://assets/sound/sfx/Hammer Hit (Brighter).wav"))
	AudioM.play_sound_varied(preload("res://assets/sound/sfx/wind1.wav"))
	AudioM.play_sound_varied(preload("res://assets/sound/sfx/short wind sound.wav"))
	UiAudioM.play_click_sound()

func stop_wind_sfx():
	A
