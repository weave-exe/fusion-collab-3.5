extends Node2D

@export var levels: Array[Level_Resource] = []

func _ready() -> void:
	LevelManager.setup($LevelContainer, levels)
	LevelManager.load_next()
	AudioGlobal.update_view("Gameplay")
