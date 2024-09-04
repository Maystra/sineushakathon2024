extends Camera3D

@export var shakeFade: float = 5.0

var offset : Vector2 = Vector2.ZERO

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake(randomStrength : float = 0.005):
	if !Settings.camera_shake:
		return
	shake_strength = randomStrength

func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#apply_shake()
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		offset = randomOffset()
	h_offset = offset.x
	v_offset = offset.y

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
