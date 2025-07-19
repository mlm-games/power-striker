class_name World extends Node3D

static var I : World
var fsm := CallableStateMachine.new()

func _init() -> void:
	I = self



#@export mass?
@export var launch_force_multiplier := 1000.0

@export var obj_velocity := Vector3.ZERO

var arrow_mvment_tween: Tween
var actual_hit_force_mult := 0.0

@onready var launchable_object: RigidBody3D = %LaunchableObject
@onready var launcher: RigidBody3D = %Launcher
@onready var ui_manager: CanvasLayer = %UIManager
@onready var camera_handler: Camera3D = %CameraHandler


func _ready() -> void:
	fsm.add_states(ready_to_launch)
	fsm.add_states(object_in_flight)
	fsm.add_states(round_over)
	fsm.set_initial_state(ready_to_launch)
	
	launchable_object.stopped_moving.connect(_on_object_stopped)
	ui_manager.power_bar.hit_requested.connect(_on_hit_requested)
	
	camera_handler.follow_target = launchable_object
	start_new_round()
	
	#arrow_mvment_tween = start_power_bar_tweening(self)
	#temp
	
	#obj_velocity += Vector3.UP
	#on_hit()

func ready_to_launch():
	pass

func object_in_flight():
	pass

func round_over():
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("launch") and fsm.current_state.get_method() == ready_to_launch.get_method():
		ui_manager.power_bar.stop_and_request_hit()
		#%OnionTestPlayer.play("hit_test")
		#arrow_mvment_tween.kill()
		#%TutorialLabel.hide() # Fade out?

func _on_hit_requested(power_ratio: float):
	if fsm.current_state != ready_to_launch:
		return
		
	fsm.change_state(object_in_flight)
	ui_manager.hide_tutorial()
	
	launcher.play_hit_animation(power_ratio)

func perform_launch(power_ratio: float):
	var final_force = launch_force_multiplier * power_ratio

	# all future effs here
	ScreenEffects.freeze_frame(0.08)
	camera_handler.apply_shake(1.5, 0.4)
	camera_handler.apply_fov_kick(15.0, 5.0)
	
	launchable_object.launch(Vector3.UP * final_force)



func _on_object_stopped():
	if fsm.current_state == object_in_flight:
		fsm.set_initial_state(round_over)
		camera_handler.return_to_home()
		ui_manager.show_round_over(launchable_object.max_height_reached)
		
		await get_tree().create_timer(3.0).timeout #TODO: Add the mid screen with the points collect popup
		start_new_round()

func start_new_round():
	fsm.change_state(ready_to_launch)
	launchable_object.reset_state()
	ui_manager.reset_ui()
	camera_handler.return_to_home()





#
#
#func _physics_process(delta: float) -> void:
	#actual_hit_force_mult *= _get_progress_with_mid_being_highest_and_corners_being_lowest()
	#actual_hit_force_mult += 10 # For 0 not actually being 0
	#%ScoreLabel.text = "Distance: %d m" % [lerpf(%WoodenBox.position.y - current_height, %WoodenBox.position.y - current_height, delta)]
	##%Camera3D.fov += wrapf(lerpf(%Camera3D.fov, %Camera3D.fov + %WoodenBox.linear_velocity.y, 0.3), 1, 179) #FIXME: Make the camera expand on impact and go down if no impact...
	#%Camera3D.rotation_degrees = Vector3.ZERO
	##TODO: Follow the box with a delay or smoothing, whichever is better for game feel?





#func _get_progress_with_mid_being_highest_and_corners_being_lowest():
	#var inv_actual_progress_mult = abs(%PathFollow2D.progress_ratio - 0.5) * 2
	#var actual_progress_mult = 1.0 - inv_actual_progress_mult
	#return actual_progress_mult
	##print(actual_progress_mult)
#
#func start_power_bar_tweening(parent): # Make it a resuable static tween in tween_component.gd?
	#var arrw_mvment_tween = parent.create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	#arrw_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarRight.global_position, arrow_loop_time)
	#arrw_mvment_tween.parallel().tween_property(%PathFollow2D, "progress_ratio", 1.0, arrow_loop_time)
	##arrw_mvment_tween.parallel().tween_property(%Smacker, "rotation_degrees:z", %Smacker.rotation_degrees.z + PI/3, arrow_loop_time)
	#
	#arrw_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarLeft.global_position, arrow_loop_time)
	##arrw_mvment_tween.parallel().tween_property(%Smacker, "rotation_degrees:z", %Smacker.rotation_degrees.z - PI/3, arrow_loop_time)
	#arrw_mvment_tween.parallel().tween_property(%PathFollow2D, "progress_ratio", 0.0, arrow_loop_time)	
	#return arrw_mvment_tween
#
#func upgrade_button_pressed(upgrade: Upgrade):
	#TODO: Set button text percentage and apply upgrade...
