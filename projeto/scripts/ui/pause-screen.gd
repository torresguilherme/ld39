extends CanvasLayer

onready var buttons = get_node("buttons").get_children()
onready var sounds = get_node("sounds")

func _ready():
	get_tree().set_pause(true)
	sounds.play("ui-pick")
	set_process(true)
	pass

func _process(delta):
	if buttons[0].is_pressed(): # || Input.is_action_pressed("ui_cancel"):
		get_tree().set_pause(false)
		queue_free()
	if buttons[1].is_pressed():
		get_tree().quit()