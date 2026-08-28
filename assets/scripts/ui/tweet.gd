extends Control
class_name Tweet

@export var text: Label
@export var account_name: Label
@export var avatar: Sprite2D

var _focus_layer: Control
var _clone: Tweet
var _tween: Tween

func _ready() -> void:
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func bind(data: TweetData, focus_layer: Control) -> void:
	_focus_layer = focus_layer
	text.text = data.text
	account_name.text = "@" + data.account_name
	avatar.region_rect = Rect2(data.avatar.x * UIG.avatar_size, data.avatar.y * UIG.avatar_size, UIG.avatar_size, UIG.avatar_size)
	
func _process(_delta: float) -> void:
	if _clone:
		_clone.position = _focus_layer.get_global_transform().affine_inverse() * global_position

func _on_focus_entered() -> void:
	if _focus_layer == null:
		return
	
	_clone = duplicate() as Tweet
	_clone.focus_mode = Control.FOCUS_NONE
	_clone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_clone.text.max_lines_visible = 4
	_focus_layer.add_child(_clone)
	
	_clone.size = size
	_clone.pivot_offset = size * 0.5
	_clone.scale = Vector2.ONE
	_clone.position = _focus_layer.get_global_transform().affine_inverse() * global_position
	
	modulate.a = 0.0	
	_kill_tween()
	_tween = create_tween()
	_tween.tween_property(_clone, "scale", Vector2(1.1, 1.1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	_tween.tween_property(_clone, "scale", Vector2(1.05, 1.05), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		
func _on_focus_exited() -> void:
	if _focus_layer == null:
		return
	if _clone == null:
		return
	
	modulate.a = 1.0
	_clone.queue_free()
	
	
func _kill_tween():
	if _tween and _tween.is_valid():
		_tween.kill()
