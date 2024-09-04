extends Control

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.ui._on_menu_pressed()

func _on_visibility_changed() -> void:
	$Items/VolumeSlider.value = Settings.volume
	$Items/DifficultySelector.select(Settings.difficulty)
	$Items/CameraShakeSelector.select(1-int(Settings.camera_shake))


func _on_difficulty_selector_item_selected(index: int) -> void:
	Settings.difficulty = index
	Settings.store_setting("difficulty", index)


func _on_camera_shake_selector_item_selected(index: int) -> void:
	var new_value : int = 1-index
	Settings.camera_shake = new_value
	Settings.store_setting("camera_shake", new_value)


func _on_volume_slider_value_changed(value: float) -> void:
	Settings.volume = value
	AudioServer.set_bus_volume_db(0, value)
	Settings.store_setting("volume", value)
