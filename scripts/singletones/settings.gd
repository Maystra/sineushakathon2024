extends Node

const SETTINGS_PATH = "user://settings.cfg"
const SETTINGS_SECTION = "settings"

enum Difficulties {EASY, MEDIUM, HARD}

var volume : float = 0.0
var camera_shake : bool = true
var difficulty : Difficulties = Difficulties.MEDIUM

func _ready() -> void:
	volume = get_setting("volume", 0.0)
	camera_shake = get_setting("camera_shake", true)
	difficulty = get_setting("difficulty", Difficulties.MEDIUM)
	AudioServer.set_bus_volume_db(0, volume)

func store_setting(key, value):
	var config = ConfigFile.new()
	config.load(SETTINGS_PATH)
	config.set_value(SETTINGS_SECTION, key, value)
	config.save(SETTINGS_PATH)

func get_setting(key, default = null):
	var config = ConfigFile.new()
	config.load(SETTINGS_PATH)
	return config.get_value(SETTINGS_SECTION, key, default)
