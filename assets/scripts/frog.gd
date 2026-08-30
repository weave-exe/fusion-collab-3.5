extends Moveable
class_name Frog
@export var frog_audiostream: AudioStreamPlayer
@export var sound_move: AudioStreamOggVorbis
@export var sound_scared: AudioStreamOggVorbis
@export var particle_timer: Timer
@export var particles: CPUParticles2D

const SPLASH_SOUND := preload("res://assets/audio/sound/water_splash.ogg")
const SPLASH_TEXTURE := preload("res://assets/misc/particles/dust.png")

var _splash_player: AudioStreamPlayer
var _submerged_state := false

func _ready() -> void:
	sprite = $FrogSprite
	$FrogSprite.play("idle_down")
	_splash_player = AudioStreamPlayer.new()
	_splash_player.stream = SPLASH_SOUND
	_splash_player.volume_db = -10.0
	_splash_player.bus = &"SFX"
	add_child(_splash_player)
	
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

func can_hop(direction: Vector2i) -> bool:
	if level.grid.is_frog_avoiding(tile + direction):
		return false
	return can_move(direction, false)

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
	
func move(direction: Vector2i) -> void:
	super.move(direction)
	_update_submerged_state(true)

func force_move(target: Vector2i) -> void:
	super.force_move(target)
	_update_submerged_state(false)
	
func _update_submerged_state(play_sound: bool) -> void:
	var curr_submerged := is_fully_submerged_in_water()
	if curr_submerged and not _submerged_state:
		if play_sound:
			_splash_player.pitch_scale = randf_range(0.9, 1.2)
			_splash_player.play()
			_splash_particles()

	
	_submerged_state = curr_submerged

func _splash_particles() -> void:
	var p := CPUParticles2D.new()
	p.texture = SPLASH_TEXTURE
	p.color = Color("1d739f")
	p.z_index = 4
	p.one_shot = true
	p.explosiveness = 1.0
	p.amount = 8
	p.lifetime = 0.5
	p.direction = Vector2.UP
	p.spread = 40.0
	p.gravity = Vector2(0, 200)
	p.initial_velocity_min = 40.0
	p.initial_velocity_max = 80.0
	p.scale_amount_min = 0.4
	p.scale_amount_max = 0.9
	
	add_child(p)
	p.global_position = level.grid.tile_to_world(tile)
	p.finished.connect(p.queue_free)
	p.emitting = true
