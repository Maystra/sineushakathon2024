extends CharacterBody3D

const MOVE_SPEED = 300
const ACCELERATION_SPEED = 10
const DECELERATION_SPEED = 10

var last_mouse_x : float = 0.0

var speed := 0.0

@export var ball : CharacterBody3D

var in_end := false

var move_vector := Vector3.ZERO

func _input(event: InputEvent) -> void:
	if !GameManager.input_active or GameManager.menu_opened:
		move_vector.x = 0
		return
	if Input.is_action_just_pressed("Launch") and !ball.launched:
		ball.launch(Vector3(0.02, 1.0, 0.0))
	if GameManager.TESTING and Input.is_action_just_pressed("DestroyBricks"):
		destroy_all_bricks()
	if event is InputEventMouseMotion and event.screen_relative.x != 0:
		if event.screen_relative.x > 0:
			move_vector.x = 1
		elif event.screen_relative.x < 0:
			move_vector.x = -1
		last_mouse_x = event.screen_relative.x
	#if Input.is_action_pressed("MoveLeft"):
		#move_vector.x = -1
	#elif Input.is_action_pressed("MoveRight"):
		#move_vector.x = 1
	#else:
		#move_vector.x = 0

func _physics_process(delta: float) -> void:
	if move_vector != Vector3.ZERO:
		speed = abs(last_mouse_x*7.5*Settings.sensitivity) # min(abs(last_mouse_x*15*Settings.sensitivity), MOVE_SPEED) # min(speed + max(abs(last_mouse_x) / 5, 2), MOVE_SPEED)
	else:
		speed = max(speed - DECELERATION_SPEED, 0)
	velocity = lerp(velocity, move_vector * speed * delta, min(20*delta, 1.0))
	match Settings.difficulty:
		Settings.Difficulties.EASY:
			scale.x = 1.5
		Settings.Difficulties.MEDIUM:
			scale.x = 1.0
		Settings.Difficulties.HARD:
			scale.x = 0.7
	move_vector.x = 0

func _process(delta: float) -> void:
	var collision_result = move_and_slide()
	if collision_result and !in_end:
		in_end = true
		end_hit_sound()
	if !collision_result:
		in_end = false
	if !ball.launched:
		ball.global_position = self.global_position + Vector3(0, 0.02, 0)

func destroy_all_bricks():
	var bricks = get_tree().get_nodes_in_group("Brick")
	for brick in bricks:
		brick.destroy()
	GameManager.emit_signal("level_finished")

func reset():
	global_position.x = 0

func end_hit_sound():
	if !$EndHitTimer.is_stopped():
		return
	GameManager.camera.apply_shake()
	GameManager.create_sound("res://sounds/platform_hit1.wav", self.global_position, -40.0)
	$EndHitTimer.start()
