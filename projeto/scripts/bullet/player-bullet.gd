extends Area2D

var speed = 500
var direction
var damage = 1
var max_range = 600
var distance_covered = 0
onready var anim = get_node("anim")

func _ready():
	if direction.x == -1:
		anim.play("left")
	else:
		anim.play("right")
	set_process(true)

func _process(delta):
	# position update
	set_global_pos(get_global_pos() + (direction * speed * delta))
	distance_covered += (speed * delta)
	if distance_covered > max_range:
		queue_free()

func _on_playerbullet_body_enter( body ):
	if body.is_in_group(global.ENEMY_GROUP) || body.is_in_group(global.WALL_GROUP):
		body.TakeDamage(damage)
		queue_free()
