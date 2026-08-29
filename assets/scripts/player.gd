extends Moveable

@export var player_audiostream: AudioStreamPlayer
@export var particles: CPUParticles2D
@export var particle_timer: Timer
@export var win_timer: Timer
@export var anim_timer: Timer
@export var reset_timer: Timer

const ALLOWED_ACTIONS := ["move_up", "move_left", "move_right", "move_down", "undo"]
const FIRST_HOLD_TIMER := 0.4
const REPEAT_RATE := 0.1
var _repeat_timer := 0.0
var _current_action := ""

func _ready() -> void:
	SignalBus.connect("level_won",win_anim)
	LevelManager.connect("level_loaded",appear_anim)

func _block_input_if_needed() -> bool:
	if UIG.phone_open:
		return true
	if LevelManager.level_completed:
		return true
	if LevelManager.level_resetting:
		return true
	return false

func _input(event: InputEvent) -> void:
	if _block_input_if_needed():
		return

	if !event.is_pressed():
		return
	if event.is_action_pressed("reset"):
		reset_anim()
		return
	
	for action in ALLOWED_ACTIONS:
		if event.is_action_pressed(action):
			_do_action(action)
			_repeat_timer = FIRST_HOLD_TIMER

			_current_action = action
			return

func _process(delta: float) -> void:
	if _block_input_if_needed():
		return
	if _current_action == "":
		return
	if not Input.is_action_pressed(_current_action):
		_current_action = ""
		return
	
	_repeat_timer -= delta
	if _repeat_timer <= 0.0:
		_do_action(_current_action)
		_repeat_timer = REPEAT_RATE
	
func _do_action(action: String) -> void:
	match action:
		"move_up":
			level.try_move(self, Vector2i.UP)
			$PlayerSprite.animation = "idle_up"
			update_player_audio("walking")
		"move_left":
			level.try_move(self, Vector2i.LEFT)
			$PlayerSprite.animation = "idle_left"
			update_player_audio("walking")
		"move_right":
			level.try_move(self, Vector2i.RIGHT)
			$PlayerSprite.animation = "idle_right"
			update_player_audio("walking")
		"move_down":
			level.try_move(self, Vector2i.DOWN)
			$PlayerSprite.animation = "idle_down"
			update_player_audio("walking")
		"undo":
			level.undo()
			update_player_audio("rewind")
			
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
	$PlayerSprite.animation="zz_appear"

	
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
	if $PlayerSprite.animation=="zz_appear":
		$PlayerSprite.animation="idle_down"
