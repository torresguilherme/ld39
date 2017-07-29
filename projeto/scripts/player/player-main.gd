extends KinematicBody2D

# stats
var speed = 350
var max_hp = 5
var hp

# shot
var shot_damage = 1
var shot_speed
var shot_cooldown
var last_shot = 0

# post-damage invulneability
var invulnerability_time = 1
var invulnerable = 0

# movement
var left = 0
var right = 0
var y_velocity = 0
var gravity_scale = 12
var jump_force = 500
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
enum mode{IDLE, WALK, JUMP, SHOT}

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
	else:
		right = 0
	if Input.is_action_pressed("ui_left") && !disable:
		left = -1
	else:
		left = 0
	
	# jump
	if !on_ground:
		y_velocity += gravity_scale
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
		last_shot = shot_cooldown
	if last_shot > 0:
		last_shot -= delta

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