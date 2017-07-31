extends KinematicBody2D

#stats
var hp = 50
var max_range = 1200
var shot_cooldown = 1.5
var last_shot = 0

# movements
var jump_force = 7
var velocity_y = 0
var gravity_scale = .1
var on_ground = false

# player localization
var initial_pos
var player_pos
var attacking = false
var in_reach = false

# nodes
onready var player = get_node("../").get_children()[0]
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")
onready var firepoints = get_node("firepoints")
onready var sounds = get_node("sounds")

# bullet
var bullet = preload("res://nodes/bullet/tengu-bullet.tscn")

func _ready():
	initial_pos = get_global_pos()
	add_to_group(global.ENEMY_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### STATE CHANGE
	#############################################
	player_pos = player.get_global_pos()
	if initial_pos.distance_to(player_pos) <= max_range:
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
	
	#############################################
	### ATTACK
	#############################################
	if attacking:
		if last_shot <= 0:
			Shoot()
			last_shot = shot_cooldown
	if last_shot > 0:
		last_shot -= delta
	
	#############################################
	### MOVEMENT
	#############################################
	if on_ground:
		velocity_y = -jump_force
	else:
		velocity_y += gravity_scale
	move(Vector2(0, velocity_y))
	
	#############################################
	### ANIMATION
	#############################################
	if player_pos.x > get_global_pos().x:
		if anim.get_current_animation() != "right":
			anim.set_current_animation("right")
	else:
		if anim.get_current_animation() != "left":
			anim.set_current_animation("left")

func Shoot():
	sounds.play("feather-shot")
	firepoints.set_rot(get_angle_to(player_pos))
	var new = []
	for i in range(firepoints.get_children().size()):
		new.append(bullet.instance())
		new[i].set_global_pos(firepoints.get_children()[i].get_global_pos())
		new[i].direction = (-Vector2((get_global_pos().x - firepoints.get_children()[i].get_global_pos().x)/25, (get_global_pos().y - firepoints.get_children()[i].get_global_pos().y)/25))
		get_node("../").add_child(new[i])

func TakeDamage(value):
	hp -= value
	if hp > 0:
		sounds.play("enemy-hurt")
		damage_anim.play("damage")
	else:
		sounds.play("enemy-death")
		remove_from_group(global.ENEMY_GROUP)
		damage_anim.play("death")