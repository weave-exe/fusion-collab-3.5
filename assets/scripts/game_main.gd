extends Node2D

@export var levels: Array[LevelResource] = []

func _ready() -> void:
	LevelManager.setup($LevelContainer, levels)
	LevelManager.load_saved_progress()
	LevelManager.load_next()
	AudioGlobal.update_view("Gameplay")
