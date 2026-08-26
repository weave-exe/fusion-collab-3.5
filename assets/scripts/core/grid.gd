extends RefCounted

class_name Grid

var terrain: TileMapLayer
var decals: TileMapLayer

func _init(_terrain: TileMapLayer, _decals: TileMapLayer) -> void:
	terrain = _terrain
	decals = _decals

func tile_to_world(tile_pos: Vector2i) -> Vector2: 
	return terrain.to_global(terrain.map_to_local(tile_pos))

func world_to_tile(world_pos: Vector2) -> Vector2i:
	return terrain.local_to_map(terrain.to_local(world_pos))

func is_blocking_player(tile: Vector2i) -> bool:
	var data := terrain.get_cell_tile_data(tile)
	if data == null:
		return true
	return data.get_custom_data("block_player")
	
func is_blocking_frog(tile: Vector2i) -> bool:
	if decals == null:
		return false
	var decal_data := decals.get_cell_tile_data(tile)
	if decal_data == null:
		return false
	return decal_data.get_custom_data("block_frog")
