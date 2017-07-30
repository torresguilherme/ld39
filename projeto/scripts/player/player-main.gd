extends KinematicBody2D

# stats
var speed = 350
var max_hp = 5
var hp

# shot
var shot_damage = 1
var shot_speed
var shot_cooldown = .4
var last_shot = 0

# post-damage invulneability
var invulnerability_time = 1
var invulnerable = 0

# movement
var left = 0
var right = 0
var y_velocity = 0
var gravity_scale = 12
var jump_force = 600
var on_ground = false
var disable = false

# animators
onready var damage_anim = get_node("damage-anim")
onready var move_anim = get_node("move-anim")

# animation control
var animation_save
var side_save
var mode_save
enum side{LEFT, RIGHT}
enum mode{IDLE, WALK, JUMP}
var current_side = RIGHT
var current_mode = IDLE

#bullet
var bullet = preload("res://nodes/bullet/player-bullet.tscn")

#firepoints
onready var sp_left = get_node("shootpoint").get_node("left")
onready var sp_right = get_node("shootpoint").get_node("right")

func _ready():
	hp = max_hp
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
		y_velocity = -jump_force
	
	#############################################
	### UPDATE POSITION
	#############################################
	move(Vector2(speed * delta * (left + right), y_velocity * delta))
	
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

func Shoot(dir):
	var new = bullet.instance()
	new.direction = Vector2(dir, 0)
	if dir == -1:
		new.set_global_pos(sp_left.get_global_pos())
	else:
		new.set_global_pos(sp_right.get_global_pos())
	get_node("../").add_child(new)

func TakeDamage(value):
	if !invulnerable:
		if hp > 1:
			hp -= value
			damage_anim.play("damage")

func Heal(value):
	hp += value
	pass

func Recharge(value):
	pass

func ReturnAnim():
	move_anim.set_current_animation(animation_save)