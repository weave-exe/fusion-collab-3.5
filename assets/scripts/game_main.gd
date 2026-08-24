extends Node2D

@export var levels: Array[PackedScene] = []

func _ready() -> void:
	LevelManager.setup($LevelContainer, levels)
	LevelManager.load_next()
