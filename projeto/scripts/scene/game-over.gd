extends Control

onready var buttons = get_node("buttons").get_children()

func _ready():
	set_process(true)
	pass

func _process(delta):
	if buttons[0].is_pressed():
		global.ChangeScene(1)
		buttons[0].is_pressed = false
	if buttons[1].is_pressed():
		get_tree().quit()