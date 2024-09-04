extends Node3D

const LEVEL1_LAYOUT = preload("res://scenes/layouts/level_1_layout.tscn")
const LEVEL2_LAYOUT = preload("res://scenes/layouts/level_2_layout.tscn")
const LEVEL3_LAYOUT = preload("res://scenes/layouts/level_3_layout.tscn")

func start_tutorial():
	$LaunchTutorial.visible = true
	$MoveTutorial.visible = true

func complete_tutorial():
	$LaunchTutorial.visible = false
	$MoveTutorial.visible = false

func clear_layout():
	change_layout()

func reset_layout():
	change_layout(LEVEL1_LAYOUT)

func next_layout():
	var next_layout
	match GameManager.level:
		1:
			next_layout = LEVEL1_LAYOUT
		2:
			next_layout = LEVEL2_LAYOUT
		3:
			next_layout = LEVEL3_LAYOUT
		_:
			GameManager.emit_signal("game_completed", GameManager.points)
			return
	change_layout(next_layout)

func change_layout(new_layout_scene = null):
	complete_tutorial()
	$Caret.reset()
	var layouts = $CurrentLayout.get_children()
	for layout in layouts:
		layout.queue_free()
	if new_layout_scene:
		var new_layout = new_layout_scene.instantiate()
		$CurrentLayout.add_child(new_layout)
