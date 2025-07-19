extends Node3D

var arrow_mvment_tween : Tween

func _ready() -> void:
	arrow_mvment_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_loops()
	arrow_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarRight.global_position, 0.5)
	arrow_mvment_tween.tween_property(%Arrow, "global_position", %PowerBarLeft.global_position, 0.5)
	
	#temp
	#on_hit()


#func on_hit():
	#Juice.squash_stretch(%Button)
