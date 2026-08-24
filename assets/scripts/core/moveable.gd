extends Node2D
class_name Moveable

@export var slide_time := 0.08

var level: Level
var tile := Vector2i.ZERO
var tween: Tween

func setup(_level: Level, _tile: Vector2i) -> void:
	level = _level
	tile = _tile
	global_position = level.grid.tile_to_world(tile)

func can_move(direction: Vector2i) -> bool:
	var target := tile + direction
	if level.grid.is_blocking_player(target):
		return false
	var moveable = level.get_moveable_at_tile(target)
	if moveable:
		return moveable.can_move(direction)
	return true

func move(direction: Vector2i) -> void:
	var moveable = level.get_moveable_at_tile(tile + direction)
	if moveable:
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
