class_name Launcher extends Node3D

@onready var animation_player: AnimationPlayer = %OnionTestPlayer

func play_hit_animation(power_ratio: float):
	#TODO: adjust animation speed based on power for game feel
	animation_player.speed_scale = 1.0 + (power_ratio * 0.5)
	animation_player.play("hit_test")
	
	#NOTE: The animation will call perform launch, as the time scale mod will not matter in this case
	
	animation_player.get_animation("hit_test").set_meta("power_ratio", power_ratio)

func _on_animation_hit_frame():
	var power = animation_player.get_animation("hit_test").get_meta("power_ratio", 0.0)
	World.I.perform_launch(power)
