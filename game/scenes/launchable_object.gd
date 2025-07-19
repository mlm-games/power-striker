class_name LaunchableObject extends RigidBody3D

static var I

func _init() -> void:
	I = self

signal height_updated(height: float)
signal stopped_moving

@export var air_resistance_factor := 0.1
@export var gravity_multiplier := 1.0

@onready var hit_particles: GPUParticles3D = %HitParticles
@onready var trail_particles: GPUParticles3D = %TrailParticles
@onready var audio_impact: AudioComponent = %Audio

var is_airborne := false
var max_height_reached := 0.0
var initial_position: Vector3

func _ready() -> void:
	initial_position = global_position
	
	sleeping_state_changed.connect(func():
		if sleeping and is_airborne:
			is_airborne = false
			stopped_moving.emit()
	)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not is_airborne:
		return
	
 
	gravity_scale *= gravity_multiplier
	
	#var drag_force = -state.linear_velocity * state.linear_velocity.length() * air_resistance_factor
	#state.apply_central_force(drag_force)
	#
	var current_height = global_position.y - initial_position.y
	if current_height > max_height_reached:
		max_height_reached = current_height
		height_updated.emit(max_height_reached)

func launch(impulse: Vector3):
	hit_particles.restart() 
	trail_particles.emitting = true 
	audio_impact.play_impact_audio()
	
	var squash_strech_tween = create_tween()
	squash_strech_tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1).set_trans(Tween.TRANS_SINE)
	squash_strech_tween.tween_property(self, "scale", Vector3.ONE, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	
	apply_central_impulse(impulse)
	is_airborne = true

func reset_state():
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	global_position = initial_position
	rotation = Vector3.ZERO
	max_height_reached = 0.0
	trail_particles.emitting = false
	is_airborne = false
	sleeping = false
