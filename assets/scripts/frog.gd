extends Moveable
class_name Frog

#to be run after player movement is calculated
func do_frog_movement(direction:Vector2i):
	#if tile - player_tile == Vector2i.DOWN:
	#	level.try_move(self, Vector2i.DOWN)
	#if tile - player_tile == Vector2i.UP:
	#	level.try_move(self, Vector2i.UP)
	#if tile - player_tile == Vector2i.LEFT:
	#	level.try_move(self, Vector2i.LEFT)
	#if tile - player_tile == Vector2i.RIGHT:
	
	level.try_move_frog(self, direction)
	
	#todo try_move isn't fantastic here because frogs don't move
	#into other frogs or logs, but will move into water
	#also todo frog avoids mushroom
