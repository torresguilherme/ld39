extends KinematicBody2D

#stats
var hp = 6
var shot_cooldown = 1
var last_shot = 0

# movements
var jump_force = 700
var velocity_y = 0
var gravity_scale = 12
var on_ground = false

# nodes
onready var player = get_node("../").get_children()[0]
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")
onready var firepoints = get_node("firepoints")

func _ready():
	add_to_group(global.ENEMY_GROUP)
	pass
