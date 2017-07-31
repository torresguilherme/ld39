extends KinematicBody2D

#stats
var hp = 25
var initialSpeed = 50
var speed = 200
var maxSpeed = 1000
var accel = 20
var slowDown = 50

#movement
var attack_max_distance = 500
var max_range = 500
var initial_pos
var player_pos
var goal_pos


#attack control
var in_reach = false
var attacking = false
var walk_direction = Vector2(0, 0)
var slowDown_direction
var pointSet = false
var goalReached = false
onready var rays = get_node("rays").get_children()

# player
onready var player = get_node("../").get_node("../").get_children()[0]

# animations
onready var anim = get_node("anim")
onready var damage_anim = get_node("damage-anim")

# sounds
onready var sounds = get_node("sounds")

func _ready():
	for i in range(4):
		rays[i].add_exception(self)
	initial_pos = get_global_pos()
	add_to_group(global.ENEMY_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### STATE CHANGE
	#############################################
	for i in range(4):
		if rays[i].is_colliding():
			var body = rays[i].get_collider()
			if body:
				if body.is_in_group(global.WALL_GROUP):
					pointSet = false
					goalReached = false
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
				if !pointSet:
					goal_pos = player_pos
					pointSet = true
					sounds.play("roar")
				
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
		if !goalReached:
			var module = sqrt(pow(get_global_pos().x - goal_pos.x, 2) + pow(get_global_pos().y - goal_pos.y, 2))
			walk_direction = Vector2((get_global_pos().x - goal_pos.x)/module, (get_global_pos().y - goal_pos.y)/module)
		else:
			walk_direction = slowDown_direction
			speed -= slowDown
			if speed <= initialSpeed:
				pointSet = false
				goalReached = false
				speed = initialSpeed
		move(-walk_direction * speed * delta)
		
		if speed < maxSpeed:
			speed += accel
		else:
			speed = maxSpeed
			
		if get_global_pos().distance_to(goal_pos) < 10:
			goalReached = true
			slowDown_direction = walk_direction
			
		
	elif get_global_pos().distance_to(initial_pos) > 10:
		var module = sqrt(pow(get_global_pos().x - initial_pos.x, 2) + pow(get_global_pos().y - initial_pos.y, 2))
		walk_direction = Vector2((get_global_pos().x - initial_pos.x)/module, (get_global_pos().y - initial_pos.y)/module)
		move(-walk_direction * speed * delta)
	
	#############################################
	### ANIMATION
	#############################################
	if walk_direction.x > 0:
		if anim.get_current_animation() != "left":
			anim.set_current_animation("left")
	else:
		if anim.get_current_animation() != "right":
			anim.set_current_animation("right")

func TakeDamage(value):
	hp -= value
	if hp > 0:
		sounds.play("enemy-hurt")
		damage_anim.play("damage")
	else:
		sounds.play("enemy-death")
		remove_from_group(global.ENEMY_GROUP)
		damage_anim.play("death")