extends Node3D

@export var air_resistance := 1.0
@export var gravity := 1.0
#@export mass?
@export var hit_force_mult := 5.0

@export var obj_velocity := Vector3.ZERO 

var arrow_mvment_tween : Tween

func _ready() -> void:
	arrow_mvment_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	arrow_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarRight.global_position, 0.5)
	arrow_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarLeft.global_position, 0.5)
	
	#temp
	
	obj_velocity += Vector3.UP * 5
	#on_hit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("launch") and event.is_pressed():
		%OnionTestPlayer.play("hit_test")

func on_hit():
	%WoodenBox.linear_velocity = obj_velocity
	%WoodenBox.apply_central_impulse(obj_velocity * hit_force_mult)
	#Juice.squash_stretch(%Button)
