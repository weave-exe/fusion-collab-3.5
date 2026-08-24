extends Node

signal level_loaded(level: Level)

var container: Node
var levels: Array[PackedScene] = []
var level_index := -1
var current_level: Level

func setup(_container: Node, _levels: Array[PackedScene]) -> void:
	container = _container
	levels = _levels
	
func load_level(i: int) -> void:
	if i < 0 or i > levels.size():
		return
		
	# remove level
	if current_level:
		container.remove_child(current_level)
		current_level.queue_free()
		
	# add new level
	level_index = i
	current_level = levels[i].instantiate() as Level
	container.add_child(current_level)
	level_loaded.emit(current_level)

func load_next() -> void:
	load_level(level_index + 1)
