extends Node2D
class_name Level

@export var terrain_layer: TileMapLayer
@export var moveables_root: Node2D
@export var decal_layer: TileMapLayer

@export var win_conditions: Array[WinCondition] = []



var grid: Grid
var moveables: Array[Moveable] = []
# currently just a raw mapping
# ["moveable": moveable, "tile": Vector2i]
var _history: Array[Array] = []

func _ready() -> void:
	grid = Grid.new(terrain_layer, decal_layer)
	_collect_movables()
	
func _collect_movables() -> void:
	for child in moveables_root.get_children():
		var moveable := child as Moveable
		if moveable == null:
			continue
		moveable.setup(self, grid.world_to_tile(moveable.global_position))
		moveables.append(moveable)

func get_moveable_at_tile(tile: Vector2i) -> Moveable:
	for moveable in moveables:
		if tile in moveable.get_occupied_tiles():
			return moveable
	return null
	
func try_move(moveable: Moveable, direction: Vector2i) -> bool:
	if not moveable.can_move(direction, true):
		return false
	_update_history()
	moveable.move(direction)
	if moveable.is_in_group("Player"):
		moveable.PlayerParticles(true)
	check_win()
	return true

#frogs can't add to the undo stack, or push things
func try_move_frog(moveable: Frog, direction: Vector2i) -> bool:
	if not moveable.can_hop(direction):
		return false
	moveable.move(direction)
	#check_win()
	return true

func undo() -> void:
	if _history.is_empty():
		return
	for record in _history.pop_back():
		record["moveable"].force_move(record["tile"])

func _update_history():
	var history_snapshot := []
	for moveable in moveables:
		history_snapshot.append({"moveable": moveable, "tile": moveable.tile})
	_history.append(history_snapshot)
	
func check_win() -> void:
	if win_conditions.size()!=0:
		for conditions in win_conditions:
			if not conditions.is_condition_met(self):
				return
		SignalBus.level_won.emit()

# for debugging
func _input(_event):
	if Input.is_action_just_pressed("debug_win"):
		SignalBus.level_won.emit()
		print("emit")
