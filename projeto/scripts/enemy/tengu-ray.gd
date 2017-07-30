extends RayCast2D

onready var tengu = get_node("../")
var body

func _ready():
	add_exception(tengu)
	set_process(true)
	pass

func _process(delta):
	if is_colliding():
		body = get_collider()
		if body:
			if body.is_in_group(global.GROUND_GROUP) || body.is_in_group(global.ENEMY_GROUP):
				tengu.on_ground = true
			else:
				tengu.on_ground = false
		else:
			tengu.on_ground = false
	else:
		tengu.on_ground = false