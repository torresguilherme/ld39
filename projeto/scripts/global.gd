extends Node

var PLAYER_BODY_GROUP = "player-body"
var PLAYER_GROUP = "player"
var GROUND_GROUP = "ground"
var WALL_GROUP = "wall"
var ENEMY_GROUP = "enemy"

# scenes
var scenes = []
var current_scene = 0
enum names{START_SCREEN, LEVEL1, ENDING, GAME_OVER}

func _ready():
	scenes.append(load("res://scenes/start-screen.tscn"))
	scenes.append(load("res://scenes/level1.tscn"))
	scenes.append(load("res://scenes/ending.tscn"))
	scenes.append(load("res://scenes/game-over.tscn"))

func ChangeScene(index):
	get_tree().change_scene_to(scenes[index])
	current_scene = index
