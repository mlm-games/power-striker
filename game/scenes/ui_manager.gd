class_name UIManager extends CanvasLayer

@onready var score_label: RichTextLabel = %ScoreLabel
@onready var tutorial_label: RichTextLabel = %TutorialLabel
@onready var round_end_panel: Panel = %RoundEndPanel
@onready var power_bar: PowerBar = %PowerBar

func _ready() -> void:
	var launchable_object = LaunchableObject.I
	launchable_object.height_updated.connect(_on_height_updated)

func _on_height_updated(height: float):
	score_label.text = "Height: %d m" % int(height)
	Juice.wobble(score_label)

func reset_ui():
	tutorial_label.visible = true
	round_end_panel.visible = false
	score_label.text = "Height: 0 m"
	power_bar.start_swinging()
	
func hide_tutorial():
	var tween = create_tween()
	tween.tween_property(tutorial_label, "modulate", Color.TRANSPARENT, 0.5)
	#tutorial_label.visible = false
	
func show_round_over(final_score: float):
	%ScoreText.text = "Max Height: %d m" % int(final_score)
	round_end_panel.visible = true
