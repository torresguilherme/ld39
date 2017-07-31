extends ProgressBar

onready var player = get_node("../").get_node("../")

func _ready():
	set_process(true)

func _process(delta):
	set_value(player.energy)