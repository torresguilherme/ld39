extends Area2D

var energy = 20

func _ready():
	pass

func _on_battery_body_enter( body ):
	if body.is_in_group(global.PLAYER_BODY_GROUP):
		body.Heal(energy)
		queue_free()