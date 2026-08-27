extends Moveable

@export var player_audiostream: AudioStreamPlayer
@export var particles: CPUParticles2D
@export var particle_timer: Timer

func _input(event: InputEvent) -> void:
	if UIG.phone_open:
		return
	if !event.is_pressed():
		return
	var _direction := Vector2i.ZERO
	
	if event.is_action_pressed("move_up"):
		level.try_move(self, Vector2i.UP)
		$PlayerSprite.animation = "idle_up"
		
		update_player_audio("walking")
	elif event.is_action_pressed("move_left"):
		level.try_move(self, Vector2i.LEFT)
		$PlayerSprite.animation = "idle_left"
		update_player_audio("walking")
	elif event.is_action_pressed("move_right"):
		level.try_move(self, Vector2i.RIGHT)
		$PlayerSprite.animation = "idle_right"
		update_player_audio("walking")
	elif event.is_action_pressed("move_down"):
		level.try_move(self, Vector2i.DOWN)
		$PlayerSprite.animation = "idle_down"
		update_player_audio("walking")
	elif event.is_action_pressed("undo"):
		level.undo()
		update_player_audio("rewind")
	elif event.is_action_pressed("reset"):
		LevelManager.reset_level()
		return
	
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
	
func update_player_audio(audio_name: String):
	if audio_name == "none":
		player_audiostream.stop()
		return

	player_audiostream["parameters/switch_to_clip"] = audio_name
	player_audiostream.play()
	
func PlayerParticles(polarity:bool):
	if polarity:
		particles.emitting=true
		particle_timer.start()
	else:
		particles.emitting=false
	


func _on_particle_timer_timeout() -> void:
	PlayerParticles(false)
	
func _on_level_0_level_won() -> void:
	print("test")


func _on_level_1_level_won() -> void:
	print("test")
