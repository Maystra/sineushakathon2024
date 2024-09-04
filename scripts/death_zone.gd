extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		body.reset()
		GameManager.emit_signal("ball_died")
