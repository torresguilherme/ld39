extends Node

var PLAYER_BODY_GROUP = "player-body"
var PLAYER_GROUP = "player"
var GROUND_GROUP = "ground"
var WALL_GROUP = "wall"
var ENEMY_GROUP = "enemy"

# scenes
var scenes = []
var current_scene = 0

func _ready():
	scenes.append(load("res://scenes/teste.tscn"))

func ChangeScene(index):
	get_tree().change_scene_to(scenes[index])
	current_scene = index
