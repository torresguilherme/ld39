extends KinematicBody2D

#stats
var hp = 5
var speed = 300

#movement
var attack_max_distance = 800
var max_range = 1000
var initial_pos
var player_pos

#attack control
var in_reach = false
var attacking = false

# player
onready var player = get_node("../").get_children()[0]

# animations
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

func _ready():
	initial_pos = get_global_pos()
	add_to_group(global.ENEMY_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### STATE CHANGE
	#############################################
	player_pos = player.get_global_pos()
	if get_global_pos().distance_to(player_pos) <= attack_max_distance:
		in_reach = true
	else:
		in_reach = false
	if in_reach:
		var vision = get_world_2d().get_direct_space_state().intersect_ray(get_global_pos(), player_pos, [self])
		if !vision.values().empty():
			if vision.values()[1].is_in_group(global.PLAYER_BODY_GROUP):
				attacking = true
			else:
				attacking = false
		else:
			attacking = false
	else:
		attacking = false
	if get_global_pos().distance_to(initial_pos) > max_range:
		attacking = false
	
	#############################################
	### MOVEMENT
	#############################################
	if attacking:
		var module = sqrt(pow(get_global_pos().x - player_pos.x, 2) + pow(get_global_pos().y - player_pos.y, 2))
		move(-Vector2((get_global_pos().x - player_pos.x)/module, (get_global_pos().y - player_pos.y)/module) * speed * delta)
	elif get_global_pos().distance_to(initial_pos) > 10:
		var module = sqrt(pow(get_global_pos().x - initial_pos.x, 2) + pow(get_global_pos().y - initial_pos.y, 2))
		move(-Vector2((get_global_pos().x - initial_pos.x)/module, (get_global_pos().y - initial_pos.y)/module) * speed * delta)

func TakeDamage(value):
	hp -= value
	if hp > 0:
		damage_anim.play("damage")
	else:
		damage_anim.play("death")