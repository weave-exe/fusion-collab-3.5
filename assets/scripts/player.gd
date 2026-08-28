extends Moveable

@export var player_audiostream: AudioStreamPlayer
@export var particles: CPUParticles2D
@export var particle_timer: Timer
@export var win_timer: Timer
@export var anim_timer: Timer
@export var reset_timer: Timer


func _ready() -> void:
	SignalBus.connect("level_won",win_anim)
	LevelManager.connect("level_loaded",appear_anim)

func _input(event: InputEvent) -> void:
	if UIG.phone_open:
		return
	if LevelManager.level_completed:
		return
	if LevelManager.level_resetting:
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
	elif event.is_action_pressed("undo", true):
		level.undo()
		update_player_audio("rewind")
	elif event.is_action_pressed("reset"):
		reset_anim()
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
func win_anim() -> void:
	LevelManager.level_completed=true
	anim_timer.start()
	win_timer.start()
func appear_anim(_1,_2) -> void:
	$PlayerSprite.animation="appear"

	
func reset_anim() -> void:
	LevelManager.level_resetting=true
	$PlayerSprite.animation="win_fast"
	reset_timer.start()
	SignalBus.level_resetting.emit()
	

func can_push_other_moveable(moveable: Moveable) -> bool:
	return not (moveable is Frog)

func _on_particle_timer_timeout() -> void:
	PlayerParticles(false)
	



func _on_win_timer_timeout() -> void:
	LevelManager.load_next()
	LevelManager.level_completed=false
	


func _on_anim_timer_timeout() -> void:
	$PlayerSprite.animation="win"
	
	
	


func _on_reset_timer_timeout() -> void:
	LevelManager.reset_level()






func _on_player_sprite_animation_looped() -> void:
# this is stupid but for some reason if i dont make appear loopable it causes all the other animations to only have one frame??
	if $PlayerSprite.animation=="appear":
		$PlayerSprite.animation="idle_down"
