class_name CameraHandler extends Camera3D

@export var follow_speed := 5.0
@export var follow_offset := Vector3(0, 4, 10) # How far to stay from the target

var follow_target: Node3D
var is_following := true
var home_position: Vector3
var home_rotation: Vector3
var fov_kick_recovery_speed := 5.0
var base_fov: float

func _ready() -> void:
	home_position = global_position
	home_rotation = rotation_degrees
	base_fov = fov

func _process(delta: float) -> void:
	if is_instance_valid(follow_target) and is_following and World.I.fsm.current_state == &"object_in_flight":
		var target_pos = follow_target.global_position + follow_offset
		global_position = global_position.lerp(target_pos, delta * follow_speed)
	
	fov = lerp(fov, base_fov, delta * fov_kick_recovery_speed)

func apply_shake(strength: float, duration: float): #Incase i add something that tweens the cam
	ScreenEffects.shake_camera_3d(self, strength, duration)

func apply_fov_kick(kick_amount: float, recovery_speed: float):
	fov += kick_amount
	fov_kick_recovery_speed = recovery_speed

func return_to_home():
	is_following = false
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", home_position, 1.0)
	tween.tween_property(self, "rotation_degrees", home_rotation, 1.0)
	tween.tween_callback(func(): is_following = true)
