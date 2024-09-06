extends CanvasLayer

const point_notification_scene = preload("res://scenes/interfaces/point_notification.tscn")

signal life_lost
signal brick_destroyed

var level
var camera

func _ready() -> void:
	$MenuScreen.visible = true
	GameManager.ui = self
	$MenuScreen/Settings/Menu.pressed.connect(_on_menu_pressed)

func _input(event: InputEvent) -> void:
	if $LoseScreen.visible and Input.is_action_just_pressed("ui_accept"):
		_on_try_again_pressed()
		get_viewport().set_input_as_handled()
	if GameManager.game_started and Input.is_action_just_pressed("ui_cancel"):
		toggle_menu()


func _physics_process(delta: float) -> void:
	$Elements/Data/Points.text = "Очки: %d" % [GameManager.points]
	$Elements/Data/Level.text = "Уровень: %d" % [GameManager.level]
	var ball_bonus = GameManager.ball.bonus
	var bonus_text : String = ""
	var bonus_duration : int = 0
	var bonus_color : Color = Color.BLACK
	match ball_bonus:
		GameManager.ball.Bonuses.SPEED:
			bonus_text = "Ускорение"
			bonus_color = GameManager.SPEED_COLOR
			bonus_duration = GameManager.ball.get_node("SpeedTimer").time_left+1
		GameManager.ball.Bonuses.SLOW:
			bonus_text = "Замедление"
			bonus_color = GameManager.SLOW_COLOR
			bonus_duration = GameManager.ball.get_node("SlowTimer").time_left+1
		GameManager.ball.Bonuses.CHARGE:
			bonus_text = "Заряд"
			bonus_color = GameManager.CHARGE_COLOR
			bonus_duration = GameManager.ball.get_node("ChargeTimer").time_left+1
	$Elements/Data/CurrentBonus.text = "%s (%dс)" % [bonus_text, bonus_duration]
	$Elements/Data/CurrentBonus["theme_override_colors/font_color"] = bonus_color
	$MenuScreen/Buttons/EndGame.visible = GameManager.game_started == true
	$MenuScreen/Buttons/Resume.visible = GameManager.game_started == true
	$MenuScreen/Buttons/StartGame.visible = GameManager.game_started == false

func show_lose_screen(points: int):
	GameManager.input_active = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$LoseScreen/VBoxContainer/LoseInfo.text = "Заработано %d очков" % [points]
	$LoseScreen/AnimationPlayer.play("show")

func show_win_screen():
	$WinScreen/CompleteSound.play()
	await get_tree().create_timer(1.0).timeout
	$WinScreen/AnimationPlayer.play("show")
	await get_tree().create_timer(0.15).timeout
	level.next_layout()

func show_end_screen(points: int):
	$EndScreen/AnimationPlayer.play("show")
	$EndScreen/VBoxContainer/EndText.text = "Ура! Вы прошли игру!\nНабрано очков: %d" % [points]
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func reset_lives():
	for live in $Elements/Lives.get_children():
		live.reset()

func _on_life_lost() -> void:
	for live in $Elements/Lives.get_children():
		if !live.active:
			continue
		live.delete()
		break


func _on_try_again_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$LoseScreen/AnimationPlayer.play("hide")
	GameManager.reset()


func _on_brick_destroyed(brick_position, brick_bonus) -> void:
	var screen_pos : Vector2 = camera.unproject_position(brick_position)
	var point_notification = point_notification_scene.instantiate()
	point_notification.update_color(brick_bonus)
	$PointsNotifications.add_child(point_notification)
	point_notification.position = screen_pos
	point_notification.update_points(GameManager.POINTS_PER_BRICK)


func _on_start_game_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.reset()
	$StartScreen/AnimationPlayer.play("start")
	$MenuScreen.visible = false
	$Elements.visible = true


func _on_settings_pressed() -> void:
	$MenuScreen/Settings.visible = true
	$MenuScreen/Buttons.visible = false


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_end_game_pressed() -> void:
	GameManager.end_game()
	$MenuScreen.visible = true
	$Elements.visible = false


func _on_resume_pressed() -> void:
	toggle_menu()

func toggle_menu():
	$MenuScreen.visible = !$MenuScreen.visible
	if $MenuScreen.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameManager.menu_opened = $MenuScreen.visible


func _on_menu_pressed() -> void:
	$MenuScreen/Settings.visible = false
	$MenuScreen/Buttons.visible = true

func _on_losescreen_menu_pressed() -> void:
	$EndScreen/AnimationPlayer.play("RESET")
	$LoseScreen/AnimationPlayer.play("RESET")
	_on_end_game_pressed()
