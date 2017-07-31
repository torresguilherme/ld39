extends Control

onready var buttons = get_node("buttons").get_children()
onready var anim = get_node("anim")
onready var controls = get_node("Panel")

func _ready():
	controls.hide()
	set_process(true)

func _process(delta):
	if buttons[0].is_pressed():
		anim.play("start")
		buttons[0].is_pressed = false
	if buttons[1].is_pressed():
		get_tree().quit()
	if buttons[2].is_pressed():
		if controls.is_hidden():
			controls.set_hidden(false)
		else:
			controls.set_hidden(true)
		buttons[2].set_pressed(false)

func Start():
	global.ChangeScene(1)