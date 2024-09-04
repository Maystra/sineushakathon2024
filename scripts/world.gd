extends Node3D

func _ready() -> void:
	$UI.level = $Level
	$UI.camera = $Level/Camera3D
	GameManager.level_node = $Level
	GameManager.caret = $Level/Caret
	GameManager.ball = $Level/Ball
	GameManager.camera = $Level/Camera3D
