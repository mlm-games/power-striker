class_name BGMPlayer extends AudioStreamPlayer

var og_pitch := 0.78

func _ready() -> void:
	bus = "Music"
	autoplay = true
	fade_in_bgm()

func fade_in_bgm(time:= 3.0) -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var initial_vol := volume_db
	volume_db = -80
	tween.tween_property(self, "volume_db", initial_vol, time)
	play()


func tween_pitch_to(val: float):
	var tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	var initial_vol := volume_db
	
