class_name PowerBar extends TextureProgressBar

static var I

func _init() -> void:
	I = self

signal hit_requested(power_ratio: float)

@export var swing_duration := 0.6

@onready var arrow: Sprite2D = %Arrow
@onready var left_marker: Marker2D = %PowerBarLeft
@onready var right_marker: Marker2D = %PowerBarRight
@onready var path_follow: PathFollow2D = %PathFollow2D

var tween: Tween

func start_swinging():
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	
	tween.tween_property(path_follow, "progress_ratio", 1.0, swing_duration)
	tween.parallel().tween_property(%Arrow, "global_position", %PowerBarRight.global_position, swing_duration)
	
	tween.tween_property(path_follow, "progress_ratio", 0.0, swing_duration)
	tween.parallel().tween_property(%Arrow, "global_position", %PowerBarLeft.global_position, swing_duration)


func stop_and_request_hit():
	#if tween and tween.is_valid(): #throwing (an err) would be better
	tween.kill()
	
	# Calculates power based on the middle being best, and corners being the worst
	var inverse_power = abs(path_follow.progress_ratio - 0.5) * 2
	var final_power_ratio = 1.0 - inverse_power
	
	final_power_ratio += 0.3 #To not feel low on start
	hit_requested.emit(final_power_ratio)
