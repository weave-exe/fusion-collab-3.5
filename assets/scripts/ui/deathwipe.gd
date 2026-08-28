extends Node2D
@export var right: ColorRect
@export var left: ColorRect
var _tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("level_won",wipe)
	LevelManager.connect("level_loaded",unwipe)
	SignalBus.connect("level_resetting",wipe_fast)

func wipe():
	_kill_tween()
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(right, "position:x", 2100, 1).set_delay(0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(left, "position:x", -2100, 1).set_delay(0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func unwipe(_1,_2):
	_kill_tween()
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(right, "position:x", 4000, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(left, "position:x", -4000, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func wipe_fast():
	_kill_tween()
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(right, "position:x", 2100, 0.6).set_delay(0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(left, "position:x", -2100, 0.6).set_delay(0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _kill_tween():
	if _tween and _tween.is_valid():
		_tween.kill()
