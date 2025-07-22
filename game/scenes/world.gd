class_name World extends Node3D

static var I : World
var fsm := CallableStateMachine.new()

@export var launch_force_multiplier := 30.0

@onready var launchable_object: LaunchableObject = %LaunchableObject
@onready var launcher: Launcher = %Launcher
@onready var ui_manager: UIManager = %UIManager
@onready var camera_handler: CameraHandler = %CameraHandler

func _ready() -> void:
	I = self
	
	fsm.add_states(ready_to_launch, enter_ready_to_launch)
	fsm.add_states(object_in_flight, Callable(), leave_object_in_flight)
	fsm.add_states(round_over, enter_round_over)

	launchable_object.stopped_moving.connect(_on_object_stopped)
	ui_manager.power_bar.hit_requested.connect(_on_hit_requested)
	
	camera_handler.follow_target = launchable_object
	fsm.set_initial_state(ready_to_launch)
	
	fsm.state_changed.connect(printt.bind(":(from -> to) States changed"))

func _physics_process(_delta: float) -> void:
	fsm.update()

func ready_to_launch(): pass
func object_in_flight(): 
	%WorldEnvironment.environment.fog_light_color.b += (launchable_object.linear_velocity.y * 0.000001)
	%WorldEnvironment.environment.fog_light_color.v -= (launchable_object.linear_velocity.y * 0.00001)
	A.bgm_player.pitch_scale = clampf(A.bgm_player.pitch_scale + launchable_object.linear_velocity.y * 0.0001, 0.78, 1)
	if launchable_object.current_height < -10.0: 
		fsm.change_state(round_over); 
		launchable_object.reset_state.call_deferred()

func round_over(): pass

func enter_ready_to_launch():
	launchable_object.reset_state()
	ui_manager.reset_ui()
	camera_handler.return_to_home()


func leave_object_in_flight():
	camera_handler.return_to_home()
	ui_manager.show_round_over(launchable_object.max_height_reached)
	ui_manager.update_points(ui_manager.points + launchable_object.max_height_reached)

func enter_round_over():
	# next round
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(fsm.change_state.bind(ready_to_launch))



func _unhandled_input(event: InputEvent) -> void:
	if fsm.current_state == &"ready_to_launch" and event.is_action_pressed("launch"):
		ui_manager.power_bar.stop_and_request_hit()

func _on_hit_requested(power_ratio: float):
	if fsm.current_state != &"ready_to_launch":
		return
		
	fsm.change_state(object_in_flight)
	ui_manager.hide_tutorial()
	launcher.play_hit_animation(power_ratio)

func perform_launch(power_ratio: float):
	var final_force = launch_force_multiplier * power_ratio
	
	launchable_object.launch(Vector3.UP * final_force)
	
	#ScreenEffects.freeze_frame(0.08)
	camera_handler.apply_shake(1.5, 0.4)
	camera_handler.apply_fov_kick(15.0, 5.0)

func _on_object_stopped():
	if fsm.current_state == &"object_in_flight":
		fsm.change_state(round_over)
