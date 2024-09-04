extends Light3D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_loops(0)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "light_energy", 0.55, 1)
	tween.tween_property(self, "light_energy", 0.75, 1)
