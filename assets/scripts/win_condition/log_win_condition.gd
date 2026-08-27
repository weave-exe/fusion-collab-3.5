extends WinCondition
class_name LogWin
 
@export var group := "Log"
@export var win_tiles_group := "WinTiles"
 
func get_goal_tiles(level: Level) -> Array[Vector2i]:
	var win_tiles_layer := level.get_tree().get_first_node_in_group(win_tiles_group) as TileMapLayer
	if win_tiles_layer == null:
		return []
	return win_tiles_layer.get_used_cells()
 
func is_condition_met(level: Level) -> bool:
	var goals := get_goal_tiles(level)
	if goals.is_empty():
		return false
	for tile in goals:
		var moveable := level.get_moveable_at_tile(tile)
		if moveable == null or not moveable.is_in_group(group):
			return false
	return true
