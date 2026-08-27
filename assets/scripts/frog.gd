extends Moveable
class_name Frog
@export var frog_audiostream: AudioStreamPlayer
@export var sound_move: AudioStreamOggVorbis
@export var sound_scared: AudioStreamOggVorbis
@export var particle_timer: Timer
@export var particles: CPUParticles2D

func _ready() -> void:
	$FrogSprite.play("idle_down")
	
func can_move(direction: Vector2i, can_push: bool) -> bool:
	#this function is mostly reimplemented instead of calling Super()
	#because I don't want the frog blocked by both player + frog blockers
	if level.grid.is_blocking_frog(tile + direction):

		frog_audiostream.stream=sound_scared
		frog_audiostream.pitch_scale=randf_range(0.9,1.2)
		frog_audiostream.play()
		return false
	for moveable in get_blocking_moveables(direction):
		if not can_push:
			frog_audiostream.stream=sound_scared
			frog_audiostream.pitch_scale=randf_range(0.9,1.2)
			frog_audiostream.play()
			return false
		if not moveable.can_move(direction, can_push):
			frog_audiostream.stream=sound_scared
			frog_audiostream.pitch_scale=randf_range(0.9,1.2)
			frog_audiostream.play()
			return false
	FrogParticles(true)
	frog_audiostream.stream=sound_move
	frog_audiostream.pitch_scale=randf_range(0.9,1.2)
	frog_audiostream.play()
	return true


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
func FrogParticles(polarity:bool):
	if polarity:
		particles.emitting=true
		particle_timer.start()
	else:
		particles.emitting=false
	

func _on_particle_timer_timeout() -> void:
	FrogParticles(false)
