extends CanvasLayer


const brick_destroy = preload("res://scenes/brick_destroy.tscn")

var materials = [
	brick_destroy
]

var frames = 0
var loaded = false


func _ready():
	for material in materials:
		var particles_instance = brick_destroy.instantiate()
		particles_instance.silent = true
		self.add_child(particles_instance)
		particles_instance.position.y += 1.0
		particles_instance.position.x += 0.75

func _physics_process(_delta):
	if frames >= 3:
		set_physics_process(false)
		loaded = true
	frames += 1
