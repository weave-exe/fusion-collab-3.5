extends WinCondition
class_name LogWin

@export var group := "Log"

func get_goal_tiles(level: Level) -> Array[Vector2i]:
	var all_tiles: Array[Vector2i] = []
	for tile in level.terrain_layer.get_used_cells():
		var tile_data := level.terrain_layer.get_cell_tile_data(tile)
		if tile_data != null and tile_data.get_custom_data("Win"):
			all_tiles.append(tile)
	return all_tiles
	
func is_condition_met(level: Level) -> bool:
	var goals = get_goal_tiles(level)
	if goals.is_empty():
		return false
	for tile in goals:
		var moveable := level.get_moveable_at_tile(tile)
		if moveable == null or not moveable.is_in_group(group):
			return false
	return true
	
