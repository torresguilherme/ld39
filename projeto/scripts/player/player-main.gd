extends KinematicBody2D

# stats
var speed = 500
var max_energy = 100
var energy
var energy_decay = 0.001
var energy_decay_in_movement = 0.003

# shot
var shot_damage = 10
var shot_speed = 600
var shot_cooldown = .4
var last_shot = 0
var shot_cost = 0.5

# post-damage invulneability
var invulnerability_time = 1
var invulnerable = 0

# movement
var left = 0
var right = 0
var y_velocity = 0
var gravity_scale = 12
var jump_force = 600
var jump_cost = 0.05
var on_ground = false
var disable = false
onready var gd = get_node("gd")

# animators
onready var damage_anim = get_node("damage-anim")
onready var move_anim = get_node("move-anim")
onready var scene_anim = get_node("../").get_node("scene-anim")
onready var red_screen = get_node("red-screen")

# animation control
enum side{LEFT, RIGHT}
enum mode{IDLE, WALK, JUMP}
var current_side = RIGHT
var current_mode = IDLE

#bullet
var strong_bullet = preload("res://nodes/bullet/strong-bullet.tscn")
var mid_bullet = preload("res://nodes/bullet/mid-bullet.tscn")
var weak_bullet = preload("res://nodes/bullet/weak-bullet.tscn")

#firepoints
onready var sp_left = get_node("shootpoint").get_node("left")
onready var sp_right = get_node("shootpoint").get_node("right")

#sounds
onready var sounds = get_node("sounds")

func _ready():
	energy = max_energy
	add_to_group(global.PLAYER_BODY_GROUP)
	set_process(true)

func _process(delta):
	#############################################
	### MOVEMENT - INPUT
	#############################################
	if Input.is_action_pressed("ui_right") && !disable:
		right = 1
		current_mode = WALK
		current_side = RIGHT
	else:
		right = 0
	if Input.is_action_pressed("ui_left") && !disable:
		left = -1
		current_mode = WALK
		current_side = LEFT
	else:
		left = 0
	if right + left == 0:
		current_mode = IDLE
	# jump
	if !on_ground:
		y_velocity += gravity_scale
		current_mode = JUMP
	else:
		y_velocity = 0
	if Input.is_action_pressed("jump") && on_ground && !disable:
		sounds.play("jump")
		y_velocity = -jump_force
		energy -= jump_cost
	
	var exception = true
	for i in range(3):
		if gd.get_children()[i].is_colliding():
			var body = gd.get_children()[i].get_collider()
			if body:
				if body.is_in_group(global.GROUND_GROUP) || body.is_in_group(global.ENEMY_GROUP):
					exception = false
	if exception:
		on_ground = false
	#############################################
	### UPDATE POSITION
	#############################################
	move(Vector2(speed * delta * (left + right), 0))
	move(Vector2(0, y_velocity * delta))
	
	#############################################
	### SHOT
	#############################################
	if Input.is_action_pressed("shot") && last_shot <= 0 && !disable:
		if current_side == LEFT:
			Shoot(-1)
		else:
			Shoot(1)
		last_shot = shot_cooldown
	if last_shot > 0:
		last_shot -= delta
	
	#############################################
	### ANIMATION
	#############################################
	if current_side == LEFT:
		move_anim.transition_node_set_current("walk", LEFT)
		move_anim.transition_node_set_current("idle", LEFT)
		move_anim.transition_node_set_current("jump", LEFT)
		move_anim.transition_node_set_current("s-jump", LEFT)
		move_anim.transition_node_set_current("s-walk", LEFT)
		move_anim.transition_node_set_current("s-idle", LEFT)
	else:
		move_anim.transition_node_set_current("walk", RIGHT)
		move_anim.transition_node_set_current("idle", RIGHT)
		move_anim.transition_node_set_current("jump", RIGHT)
		move_anim.transition_node_set_current("s-jump", RIGHT)
		move_anim.transition_node_set_current("s-walk", RIGHT)
		move_anim.transition_node_set_current("s-idle", RIGHT)
	
	if current_mode == IDLE:
		move_anim.transition_node_set_current("non-shoot", IDLE)
		move_anim.transition_node_set_current("shoot", IDLE)
	elif current_mode == WALK:
		move_anim.transition_node_set_current("non-shoot", WALK)
		move_anim.transition_node_set_current("shoot", WALK)
	else:
		move_anim.transition_node_set_current("non-shoot", JUMP)
		move_anim.transition_node_set_current("shoot", JUMP)
	if last_shot > 0:
		move_anim.transition_node_set_current("final", 1)
	else:
		move_anim.transition_node_set_current("final", 0)
	
	#############################################
	### ENERGY DECAY
	#############################################
	if current_mode:
		energy -= energy_decay_in_movement
	else:
		energy -= energy_decay
	speed = 500 - 3*(max_energy - energy)
	shot_damage = 10 - 0.08*(max_energy - energy)
	shot_speed = 600 - 3*(max_energy - energy)
	shot_cooldown = .4 + 0.01*(max_energy - energy)
	if energy < 20:
		red_screen.set_opacity(0.5 - (energy * 0.025))
	else:
		red_screen.set_opacity(0)
	if energy <= 0:
		scene_anim.play("game-over")
		set_process(false)

func Shoot(dir):
	var new
	if energy > 60:
		new = strong_bullet.instance()
		sounds.play("heavy-shot")
	elif energy <= 60 && energy > 30:
		new = mid_bullet.instance()
		sounds.play("light-shot")
	else:
		new = weak_bullet.instance()
		sounds.play("light-shot")
	new.direction = Vector2(dir, 0)
	new.speed = shot_speed
	new.damage = shot_damage
	if dir == -1:
		new.set_global_pos(sp_left.get_global_pos())
	else:
		new.set_global_pos(sp_right.get_global_pos())
	get_node("../").add_child(new)
	energy -= shot_cost

func TakeDamage(value):
	if !invulnerable:
		energy -= value
		if energy > 0:
			sounds.play("player-hurt")
			damage_anim.play("damage")
		else:
			pass

func Heal(value):
	sounds.play("heal")
	energy += value
	if energy > max_energy:
		energy = max_energy