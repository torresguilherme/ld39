extends Area2D

onready var scene_anim = get_node("../").get_node("scene-anim")

func _ready():
	pass

func _on_objective_body_enter( body ):
	if body.is_in_group(global.PLAYER_BODY_GROUP):
		scene_anim.play("next")
