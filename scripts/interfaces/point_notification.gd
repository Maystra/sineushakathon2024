extends Control

func update_points(points : int):
	$Label.text = "+%d" % [points]

func update_color(bonus):
	match bonus:
		1:
			$Label["theme_override_colors/font_color"] = GameManager.SPEED_COLOR
		2:
			$Label["theme_override_colors/font_color"] = GameManager.SLOW_COLOR
		3:
			$Label["theme_override_colors/font_color"] = GameManager.CHARGE_COLOR

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
