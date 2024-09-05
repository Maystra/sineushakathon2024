extends Node

const TESTING = false

const POINTS_PER_BRICK = 10

const SPEED_COLOR = Color("#7575ff")
const SLOW_COLOR = Color("#57ff8b")
const CHARGE_COLOR = Color("#ff8400")

signal ball_died
signal level_finished
signal game_completed

var points := 0
var lives := 3
var level := 1

var input_active := false
var game_started := false

var ui : CanvasLayer
var caret: Node3D
var ball: Node3D
var level_node : Node3D
var camera : Camera3D

func end_game():
	reset()
	game_started = false
	level_node.clear_layout()
	level_node.start_tutorial()
	input_active = false

func reset():
	level = 1
	lives = 3
	points = 0
	input_active = true
	game_started = true
	caret.reset()
	ball.reset_bonus()
	ui.reset_lives()
	ball.launched = false
	level_node.reset_layout()
	level_node.start_tutorial()

func add_points():
	points += POINTS_PER_BRICK

func _on_ball_died() -> void:
	camera.apply_shake(0.01)
	lives -= 1
	ui.emit_signal("life_lost")
	if lives <= 0:
		game_started = false
		ui.show_lose_screen(GameManager.points)

func _on_level_finished() -> void:
	level += 1
	ui.show_win_screen()
	ball.reset()

func create_sound(path, position, volume = 0.0):
	var end_hit_sound = AudioStreamPlayer3D.new()
	end_hit_sound.stream = load(path)
	end_hit_sound.volume_db = volume
	end_hit_sound.pitch_scale = randf_range(0.95, 1.05)
	GameManager.level_node.add_child(end_hit_sound)
	end_hit_sound.global_position = position
	end_hit_sound.play()


func _on_game_completed(points: int) -> void:
	input_active = false
	game_started = false
	ui.show_end_screen(points)
