extends CharacterBody3D

var MOVE_SPEED = 1

enum Bonuses {NONE, SPEED, SLOW, CHARGE}

var bonus : Bonuses = Bonuses.NONE
var launched := false

var velocity_vector := Vector3.ZERO

func launch(new_direction):
	velocity_vector = new_direction
	launched = true
	$BallLaunch.play()
	GameManager.camera.apply_shake()

func reset():
	launched = false
	velocity = Vector3.ZERO
	$BallFall.play()
	reset_bonus()

func set_bonus(new_bonus : Bonuses = Bonuses.NONE):
	reset_bonus()
	bonus = new_bonus
	match new_bonus:
		Bonuses.SPEED:
			$SpeedTimer.start()
		Bonuses.SLOW:
			$SlowTimer.start()
		Bonuses.CHARGE:
			$ChargeTimer.start()

func _process(delta: float) -> void:
	var is_charged : bool = bonus == Bonuses.CHARGE
	$OmniLight3D.visible = is_charged
	$MeshInstance3D["surface_material_override/0"].emission_enabled = is_charged
	if bonus == Bonuses.SPEED:
		MOVE_SPEED = 1.3
	elif bonus == Bonuses.SLOW:
		MOVE_SPEED = 0.7
	else:
		MOVE_SPEED = 1
	match Settings.difficulty:
		Settings.Difficulties.EASY:
			MOVE_SPEED = MOVE_SPEED*0.7
		Settings.Difficulties.MEDIUM:
			MOVE_SPEED = MOVE_SPEED*0.8
		Settings.Difficulties.HARD:
			MOVE_SPEED = MOVE_SPEED*1.0
	if !launched:
		global_position.y = -0.123
		return
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.name == "Caret":
			var collision_angle = collider.global_position.direction_to(self.global_position)
			collision_angle.x = clamp(collision_angle.x, -0.2, 0.2)
			collision_angle = collision_angle.normalized()
			velocity_vector = collision_angle
		else:
			if (!collider.is_in_group("Brick") or bonus != Bonuses.CHARGE) and (!collider.is_in_group("Brick") or collider.bonus != collider.BrickBonus.CHARGE):
				velocity_vector = velocity_vector.bounce(collision_info.get_normal())
				velocity_vector.x = clamp(velocity_vector.x, -0.7, 0.7)
				velocity_vector = velocity_vector.normalized()
		if collider.is_in_group("Brick"):
			match collider.bonus:
				collider.BrickBonus.SPEED:
					set_bonus(Bonuses.SPEED)
				collider.BrickBonus.SLOW:
					set_bonus(Bonuses.SLOW)
				collider.BrickBonus.CHARGE:
					set_bonus(Bonuses.CHARGE)
			collider.destroy()
		else:
			GameManager.create_sound("res://sounds/hit/metal1.wav", self.global_position, -30.0)
		GameManager.camera.apply_shake()
	velocity = velocity_vector * MOVE_SPEED
	velocity.z = 0.0


func reset_bonus() -> void:
	$SpeedTimer.stop()
	$SlowTimer.stop()
	$ChargeTimer.stop()
	bonus = Bonuses.NONE
