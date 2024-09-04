extends CharacterBody3D

const MOVE_SPEED = 110

@export var ball : CharacterBody3D

var in_end := false

var move_vector := Vector3.ZERO

func _input(event: InputEvent) -> void:
	if !GameManager.input_active:
		move_vector.x = 0
		return
	if Input.is_action_just_pressed("Launch") and !ball.launched:
		ball.launch(Vector3(0.02, 1.0, 0.0))
	if GameManager.TESTING and Input.is_action_just_pressed("DestroyBricks"):
		destroy_all_bricks()
	#if event is InputEventMouseMotion:
		#print(event.velocity)
		#if event.velocity.x > 0:
			#move_vector.x = 1
		#elif event.velocity.x < 0:
			#move_vector.x = -1
		#else:
			#move_vector.x = 0
	#else:
	if Input.is_action_pressed("MoveLeft"):
		move_vector.x = -1
	elif Input.is_action_pressed("MoveRight"):
		move_vector.x = 1
	else:
		move_vector.x = 0

func _physics_process(delta: float) -> void:
	velocity = lerp(velocity, move_vector * MOVE_SPEED * delta, min(14*delta, 1.0))
	match Settings.difficulty:
		Settings.Difficulties.EASY:
			scale.x = 1.5
		Settings.Difficulties.MEDIUM:
			scale.x = 1.0
		Settings.Difficulties.HARD:
			scale.x = 0.7

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
