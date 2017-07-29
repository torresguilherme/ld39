extends Area2D

var speed = 0
var direction = Vector2(0, 0)
var damage = 1
var max_range = 600
var distance_covered = 0

func _ready():
	set_process(true)
	pass

func _process(delta):
	# position update
	set_global_pos(get_global_pos() + (direction * speed * delta))
	distance_covered += (speed * delta)
	if distance_covered > max_range:
		queue_free()

func _on_playerbullet_body_enter( body ):
	if body.is_in_group(global.ENEMY_GROUP):
		body.TakeDamage(damage)
		queue_free()
