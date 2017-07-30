extends Area2D

var damage = 1

func _ready():
	pass

func _on_hurtbox_body_enter( body ):
	if body.is_in_group(global.PLAYER_BODY_GROUP):
		body.TakeDamage(damage)
