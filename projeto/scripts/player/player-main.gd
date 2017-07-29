extends KinematicBody2D

# stats
var speed = 350
# para ser preenchido com o resto dos stats

# movement
var left = 0
var right = 0
var y_velocity = 0
var gravity_scale = 10
var jump_force = 500
var on_ground = false
var disable = false

func _ready():
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
	if Input.is_action_pressed("jump") && on_ground:
		y_velocity = -jump_force
	
	#############################################
	### UPDATE POSITION
	#############################################
	move(Vector2(speed * delta * (left + right), y_velocity * delta))

func TakeDamage(value):
	pass

func Heal(value):
	pass

func Recharge(value):
	pass