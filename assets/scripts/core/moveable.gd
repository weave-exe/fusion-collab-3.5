extends Node2D
class_name Moveable

@export var slide_time := 0.08

@export var shape: Array[Vector2i] = [Vector2i.ZERO]

var level: Level
var tile := Vector2i.ZERO
var tween: Tween

func setup(_level: Level, _tile: Vector2i) -> void:
	level = _level
	tile = _tile
	global_position = level.grid.tile_to_world(tile)

func can_move(direction: Vector2i, can_push: bool) -> bool:
	for offset in shape:
		var target := tile + offset + direction
		if level.grid.is_blocking_player(target):
			return false
	for moveable in get_blocking_moveables(direction):
		if not can_push:
			return false
		if not moveable.can_move(direction, can_push):
			return false
	return true

func move(direction: Vector2i) -> void:
	for moveable in get_blocking_moveables(direction):
		moveable.move(direction)
	tile += direction
	slide(level.grid.tile_to_world(tile))
	
	
func force_move(target: Vector2i) -> void:
	tile = target
	slide(level.grid.tile_to_world(tile))

func slide(target: Vector2) -> void:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position", target, slide_time)
	
func get_occupied_tiles() -> Array[Vector2i]:
	var tiles: Array[Vector2i] = []
	for offset in shape:
		tiles.append(tile + offset)
	return tiles
	
func get_blocking_moveables(direction: Vector2i) -> Array[Moveable]:
	var block: Array[Moveable] = []
	for offset in shape:
		var target := tile + offset + direction
		var other := level.get_moveable_at_tile(target)
		if other != null and other != self and not block.has(other):
			block.append(other)
	return block
