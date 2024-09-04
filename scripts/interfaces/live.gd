extends Control

var active := true

func reset():
	active = true
	$AnimationPlayer.play("RESET")

func delete():
	active = false
	$AnimationPlayer.play("delete")
