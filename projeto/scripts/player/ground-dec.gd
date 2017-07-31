extends RayCast2D

onready var player = get_node("../").get_node("../")
var body

func _ready():
	add_exception(player)
	set_process(true)
	pass

func _process(delta):
	if is_colliding():
		body = get_collider()
		if body:
			if body.is_in_group(global.GROUND_GROUP) || body.is_in_group(global.ENEMY_GROUP):
				player.on_ground = true