extends Light3D

var blink_timer

const MIN_WAIT_TIME = 5.0
const MAX_WAIT_TIME =  20.0

func _ready() -> void:
	blink_timer = Timer.new()
	blink_timer.wait_time = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	blink_timer.one_shot = true
	blink_timer.timeout.connect(blink)
	add_child(blink_timer)
	blink_timer.start()

func blink():
	var blink_tween = get_tree().create_tween()
	var old_energy = light_energy
	for i in range(randi_range(3,5)):
		blink_tween.tween_property(self, "light_energy", 0.05, 0.03)
		blink_tween.tween_property(self, "light_energy", old_energy, 0.06)
	blink_timer.wait_time = randf_range(MIN_WAIT_TIME, MAX_WAIT_TIME)
	blink_timer.start()
