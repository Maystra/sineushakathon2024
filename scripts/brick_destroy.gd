extends Node3D

var silent := false

var brick_material

func _ready() -> void:
	$Bricks.draw_pass_1.material = brick_material
	$Dust.emitting = true
	$Bricks.emitting = true
	if !silent:
		$Sound.pitch_scale = randf_range(0.95, 1.05)
		$Sound.play()

func _on_sound_finished() -> void:
	queue_free()
