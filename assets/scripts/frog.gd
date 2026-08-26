extends Moveable
class_name Frog

func _ready() -> void:
	$FrogSprite.play("idle_down")
	
func can_move(direction: Vector2i, can_push: bool) -> bool:
	if level.grid.is_blocking_frog(tile + direction):
		print("Frog is blocked")
		return false
	return super.can_move(direction, can_push)
		
#to be run after player movement is calculated
func do_frog_movement(direction:Vector2i):
	if direction == Vector2i.DOWN:
		$FrogSprite.animation = "idle_down"
	if direction == Vector2i.UP:
		$FrogSprite.animation = "idle_up"
	if direction == Vector2i.LEFT:
		$FrogSprite.animation = "idle_left"
	if direction == Vector2i.RIGHT:
		$FrogSprite.animation = "idle_right"
	level.try_move_frog(self, direction)
	
	#todo try_move isn't fantastic here because frogs don't move
	#into other frogs or logs, but will move into water
	#also todo frog avoids mushroom
