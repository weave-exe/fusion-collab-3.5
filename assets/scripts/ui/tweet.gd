extends Control
class_name Tweet

@export var text: Label
@export var account_name: Label
@export var avatar: Sprite2D

func _ready() -> void:
	focus_entered.connect(func(): modulate = Color(0.69, 0.69, 0.69, 1.0))
	focus_exited.connect(func(): modulate = Color.WHITE)

func bind(data: TweetData) -> void:
	text.text = data.text
	account_name.text = "@" + data.account_name
	avatar.region_rect = Rect2(data.avatar.x * UIG.avatar_size, data.avatar.y * UIG.avatar_size, UIG.avatar_size, UIG.avatar_size)
