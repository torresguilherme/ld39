extends Node2D

var pause_screen = preload("res://nodes/ui/pause-screen.tscn")

func _ready():
	set_process(true)
	pass

func _process(delta):
	if Input.is_action_pressed("ui_cancel"):
		var ps = pause_screen.instance()
		add_child(ps)