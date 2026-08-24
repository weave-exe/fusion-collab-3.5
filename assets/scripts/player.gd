extends Moveable

func _input(event: InputEvent) -> void:
	if !event.is_pressed():
		return
	var direction := Vector2i.ZERO
	
	if event.is_action_pressed("move_up"):
		level.try_move(self, Vector2i.UP)
	elif event.is_action_pressed("move_left"):
		level.try_move(self, Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		level.try_move(self, Vector2i.RIGHT)
	elif event.is_action_pressed("move_down"):
		level.try_move(self, Vector2i.DOWN)
	elif event.is_action_pressed("undo"):
		level.undo()
