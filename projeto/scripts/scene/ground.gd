extends StaticBody2D

func _ready():
	add_to_group(global.GROUND_GROUP)
	add_to_group(global.WALL_GROUP)
	pass
