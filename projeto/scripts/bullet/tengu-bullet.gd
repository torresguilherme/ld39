extends Area2D

var speed = 150
var direction = Vector2(0, 0)
var max_range = 1000
var distance = 0
var damage = 5

func _ready():
	look_at(get_global_pos() + direction)
	set_process(true)

func _process(delta):
	set_global_pos(get_global_pos() + direction * speed * delta)
	distance += speed * delta
	if distance > max_range:
		queue_free()

func _on_tengubullet_body_enter( body ):
	if body.is_in_group(global.PLAYER_BODY_GROUP):
		body.TakeDamage(damage)
	if body.is_in_group(global.PLAYER_BODY_GROUP) || body.is_in_group(global.WALL_GROUP):
		queue_free()
