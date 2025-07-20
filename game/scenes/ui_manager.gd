class_name UIManager extends CanvasLayer

@onready var score_label: RichTextLabel = %ScoreLabel
@onready var tutorial_label: RichTextLabel = %TutorialLabel
@onready var round_end_panel: Panel = %RoundEndPanel
@onready var power_bar: PowerBar = %PowerBar
@onready var strength_button: AnimButton = %StrengthButton
@onready var dampness_button: AnimButton = %DampnessButton
@onready var aerodynamics_button: AnimButton = %AerodynamicsButton
@onready var force_mult_text: RichTextLabel = %ForceMultText

var points := 0

func _ready() -> void:
	var launchable_object = LaunchableObject.I
	launchable_object.height_updated.connect(_on_height_updated)
	strength_button.pressed.connect(_on_upgrade_button_pressed)
	dampness_button.pressed.connect(_on_upgrade_button_pressed)
	aerodynamics_button.pressed.connect(_on_upgrade_button_pressed)

func _on_height_updated(height: float):
	score_label.text = "[wave]Height: %d m" % int(height)
	Juice.wobble(score_label)
	
func _on_force_mult_updated(force_mult: float):
	force_mult_text.text = "[wave]Force multiplier: %d" % int(force_mult)

func update_points(pts):
	points = pts
	UIEffects.animate_number(%PointsLabel, int(%PointsLabel.text), points, 0.5)

func reset_ui():
	tutorial_label.visible = true
	round_end_panel.get_node("PopupAnimator").animate_out()
	score_label.text = "Height: 0 m"
	power_bar.start_swinging()
	
func hide_tutorial():
	var tween = create_tween()
	tween.tween_property(tutorial_label, "modulate", Color.TRANSPARENT, 0.5)
	#tutorial_label.visible = false
	
func show_round_over(final_score: float):
	%ScoreText.text = "[color=alice_blue]Max Height: %d m" % int(final_score)
	round_end_panel.visible = true
	round_end_panel.get_node("PopupAnimator").animate_in()

func _on_upgrade_button_pressed():
	if points >= 10:
		update_points(points - 10)
		World.I.launch_force_multiplier += 1
		_on_force_mult_updated(World.I.launch_force_multiplier)
