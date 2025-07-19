extends Node3D

@export var air_resistance := 1.0
@export var gravity := 1.0 #Reduces with aero dynamics
#@export mass?
@export var hit_force_mult_upgrade := 100.0
@export var arrow_loop_time := 0.6

@export var obj_velocity := Vector3.ZERO

var arrow_mvment_tween: Tween
var actual_hit_force_mult := 0.0

@onready var current_height: float = %WoodenBox.position.y

func _ready() -> void:
	arrow_mvment_tween = start_power_bar_tweening(self)
	#temp
	
	obj_velocity += Vector3.UP
	#on_hit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("launch") and event.is_pressed():
		%OnionTestPlayer.play("hit_test")
		arrow_mvment_tween.kill()
		%TutorialLabel.hide() # Fade out?

func on_hit():
	print("Hit force mult: ", actual_hit_force_mult)
	
	await ScreenEffects.freeze_frame(0.08)
	%WoodenBox.linear_velocity = obj_velocity
	%WoodenBox.apply_central_impulse(obj_velocity * actual_hit_force_mult)
	
	arrow_mvment_tween = start_power_bar_tweening(self) #TODO: Only start when the box is broken or reached max height, show a popup and then start
	await arrow_mvment_tween.loop_finished
	%OnionTestPlayer.play("reset_rot")
	#Juice.squash_stretch(%Button)


func _physics_process(delta: float) -> void:
	actual_hit_force_mult *= _get_progress_with_mid_being_highest_and_corners_being_lowest()
	actual_hit_force_mult += 10 # For 0 not actually being 0
	%ScoreLabel.text = "Distance: %d m" % [lerpf(%WoodenBox.position.y - current_height, %WoodenBox.position.y - current_height, delta)]
	#%Camera3D.fov += wrapf(lerpf(%Camera3D.fov, %Camera3D.fov + %WoodenBox.linear_velocity.y, 0.3), 1, 179) #FIXME: Make the camera expand on impact and go down if no impact...
	%Camera3D.rotation_degrees = Vector3.ZERO
	#TODO: Follow the box with a delay or smoothing, whichever is better for game feel?


func _get_progress_with_mid_being_highest_and_corners_being_lowest():
	var inv_actual_progress_mult = abs(%PathFollow2D.progress_ratio - 0.5) * 2
	var actual_progress_mult = 1.0 - inv_actual_progress_mult
	return actual_progress_mult
	#print(actual_progress_mult)

func start_power_bar_tweening(parent): # Make it a resuable static tween in tween_component.gd?
	var arrw_mvment_tween = parent.create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	arrw_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarRight.global_position, arrow_loop_time)
	arrw_mvment_tween.parallel().tween_property(%PathFollow2D, "progress_ratio", 1.0, arrow_loop_time)
	#arrw_mvment_tween.parallel().tween_property(%Smacker, "rotation_degrees:z", %Smacker.rotation_degrees.z + PI/3, arrow_loop_time)
	
	arrw_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarLeft.global_position, arrow_loop_time)
	#arrw_mvment_tween.parallel().tween_property(%Smacker, "rotation_degrees:z", %Smacker.rotation_degrees.z - PI/3, arrow_loop_time)
	arrw_mvment_tween.parallel().tween_property(%PathFollow2D, "progress_ratio", 0.0, arrow_loop_time)	
	return arrw_mvment_tween

#func upgrade_button_pressed(upgrade: Upgrade):
	#TODO: Set button text percentage and apply upgrade...
