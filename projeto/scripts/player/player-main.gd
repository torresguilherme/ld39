extends RigidBody2D

# stats
var speed
# para ser preenchido com o resto dos stats

# movement
var on_ground = false

func _ready():
	add_to_group(global.PLAYER_BODY_GROUP)
	set_process(true)

func _process(delta):
	pass
