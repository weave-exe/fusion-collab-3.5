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
	
	#this sucks I'll change it later
	var frog = level.get_moveable_at_tile(tile + Vector2i.UP)
	if frog as Frog != null:
		frog.do_frog_movement(Vector2i.UP)
	frog = level.get_moveable_at_tile(tile + Vector2i.DOWN)
	if frog as Frog != null:
		frog.do_frog_movement(Vector2i.DOWN)
	frog = level.get_moveable_at_tile(tile + Vector2i.LEFT)
	if frog as Frog != null:
		frog.do_frog_movement(Vector2i.LEFT)
	frog = level.get_moveable_at_tile(tile + Vector2i.RIGHT)
	if frog as Frog != null:
		frog.do_frog_movement(Vector2i.RIGHT)
