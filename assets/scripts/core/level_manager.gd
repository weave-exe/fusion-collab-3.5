extends Node

signal level_loaded(level: Level, zoom: int)
signal layer_array(layers)
signal level_reset()


var container: Node
var levels: Array[LevelResource] = []
var level_index := -1
var furthest_level:int=0
var current_level: Level
var current_level_resource: LevelResource
var level_completed:bool=false
var level_resetting:bool=false
var layers: Array

var _block_transition_inputs = false

func setup(_container: Node, _levels: Array[LevelResource]) -> void:
	container = _container
	levels = _levels
	
func load_level(i: int) -> void:
	if i < 0 or i >= levels.size():
		return
	_block_transition_inputs = true
	# remove level
	if current_level:
		container.remove_child(current_level)
		current_level.queue_free()
		
	# add new level
	level_index = i
	current_level_resource = levels[i]
	current_level = current_level_resource.scene.instantiate() as Level
	container.add_child(current_level)
	level_loaded.emit(current_level, levels[i].zoom)
	layers.clear()
	for j in levels[i].music_layers.size():
		layers.append(levels[i].music_layers[j])
	layer_array.emit(layers)
	if level_index > furthest_level:
		furthest_level=level_index
	
	get_tree().create_timer(1.0).timeout.connect(
		func(): _block_transition_inputs = false
	)

func load_next() -> void:
	load_level(level_index + 1)

func reset_level() -> void:
	load_level(level_index)
	level_reset.emit()
	level_resetting=false

func is_input_blocked() -> bool:
	return _block_transition_inputs or level_completed or level_resetting
