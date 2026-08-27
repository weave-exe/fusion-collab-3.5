extends Moveable
#class_name Log

func can_move(direction: Vector2i, can_push: bool) -> bool:
	#this function is mostly reimplemented instead of calling Super()
	#because I don't want the frog blocked by both player + frog blockers
	if level.grid.is_blocking_log(tile + direction):
		return false
	for moveable in get_blocking_moveables(direction):
		if not can_push:
			return false
		if not moveable.can_move(direction, can_push):
			return false
	return true
