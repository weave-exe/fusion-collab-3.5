extends Node2D
class_name Moveable

var tile := Vector2i.ZERO
var tween: Tween

func _enter_tree() -> void:
	Level.moveables.append(self)

func _exit_tree() -> void:
	Level.moveables.erase(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile = global_position / 16 #Assuming 16x16 tiles
	global_position = tile * 16.0 + Vector2(8.0, 8.0) #Adding an offset to the position so the character is inside the tile

func can_move(direction: Vector2i) -> bool:
	if Level.is_tile_wall(tile + direction):
		return false
	var moveable = Level.get_moveable_at_tile(tile + direction)
	if moveable:
		return moveable.can_move(direction)
	return true

func move(direction: Vector2i) -> void:
	var moveable = Level.get_moveable_at_tile(tile + direction)
	if moveable:
		moveable.move(direction)
	slide(direction)
	
	Level.add_move_to_turn(self, direction)

func slide(direction: Vector2i) -> void:
	global_position = tile * 16.0 + Vector2(8.0, 8.0)
	tile += direction
	
	var target := tile * 16.0 + Vector2(8.0, 8.0)
	tween = create_tween()
	tween.tween_property(self, "global_position", target, 0.08)
