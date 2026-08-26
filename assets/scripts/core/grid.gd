extends RefCounted

class_name Grid

var terrain: TileMapLayer

func _init(_terrain: TileMapLayer) -> void:
	terrain = _terrain
	
func tile_to_world(tile_pos: Vector2i) -> Vector2: 
	return terrain.to_global(terrain.map_to_local(tile_pos))

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return terrain.local_to_map(terrain.to_local(world_pos))

func is_blocking_player(tile: Vector2i) -> bool:
	var data := terrain.get_cell_tile_data(tile)
	if data == null:
		return true
	return data.get_custom_data("block_player")
	
func is_frog_block():
	pass
