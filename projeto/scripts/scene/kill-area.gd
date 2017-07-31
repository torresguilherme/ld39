extends Area2D

func _ready():
	pass


func _on_killarea_body_enter( body ):
	if body.is_in_group(global.PLAYER_BODY_GROUP):
		body.energy_decay_in_movement = 2
