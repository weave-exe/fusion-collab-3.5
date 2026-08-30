extends Moveable
#class_name Log
@export var sound_player: AudioStreamPlayer
@export var sound_logs: Array[AudioStreamOggVorbis]

const SPLASH_SOUND := preload("res://assets/audio/sound/water_splash.ogg")
const SPLASH_TEXTURE := preload("res://assets/misc/particles/dust.png")

var _splash_player: AudioStreamPlayer
var _submerged_state := false
var _animation_tweens: Array[Tween] = []

func _ready() -> void:
	_splash_player = AudioStreamPlayer.new()
	_splash_player.stream = SPLASH_SOUND
	_splash_player.volume_db = -10.0
	_splash_player.bus = &"SFX"
	add_child(_splash_player)
	
func setup(_level: Level, _tile: Vector2i) -> void:
	super.setup(_level, _tile)
	_update_submerged_state(false)

func can_move(direction: Vector2i, can_push: bool) -> bool:
	#this function is mostly reimplemented instead of calling Super()
	#because I don't want the frog blocked by both player + frog blockers
	for offset in shape:
		if level.grid.is_blocking_log(tile + offset + direction):
			return false
		for moveable in get_blocking_moveables(direction):
			if not can_push:
				return false
			if not can_push_other_moveable(moveable):
				return false
			if not moveable.can_move(direction, can_push):
				return false
	sound_player.stream=sound_logs.pick_random()
	sound_player.pitch_scale=randf_range(0.9,1.2)
	sound_player.play()
	return true

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
			# particle effects
			for offset in shape:
				var log_tile = tile + offset
				_splash_particles(log_tile)
		_start_bobbing()
	elif not curr_submerged and _submerged_state:
		_stop_bobbing()
	
	_submerged_state = curr_submerged


func _get_log_sprites() -> Array[Node2D]:
	var sprites: Array[Node2D] = []
	for child in get_children():
		if child is Sprite2D:
			sprites.append(child)
	return sprites

func _start_bobbing() -> void:
	_kill_tweens()
	for sprite in _get_log_sprites():
		var tween = create_tween().set_loops()
		tween.tween_property(sprite, "offset:y", 2, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite, "offset:y", 0, 1.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		_animation_tweens.append(tween)

func _stop_bobbing() -> void:
	_kill_tweens()
	for sprite in _get_log_sprites():
		sprite.offset.y = 0

func _kill_tweens():
	for _tween in _animation_tweens:
		if _tween and _tween.is_valid():
			_tween.kill()
	_animation_tweens.clear()

func _splash_particles(tile: Vector2i) -> void:
	var p := CPUParticles2D.new()
	p.texture = SPLASH_TEXTURE
	p.color = Color("1d739f")
	p.position = to_local(level.grid.tile_to_world(tile))
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
	
	p.finished.connect(p.queue_free)
	p.emitting = true
