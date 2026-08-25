extends Node2D

@export var phone: Node2D
@export var dark_overlay: CanvasItem
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func EnableTwitter():
	AudioGlobal.update_view("Twitter")
	UIG.twitter_open=true
	phone.visible=true
	# tween stuff
	dark_overlay.visible=true
	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0)
	dark_tween.tween_property(dark_overlay, "modulate:a", 1, 0.7)
	
func DisableTwitter():
	AudioGlobal.update_view("Gameplay")
	UIG.twitter_open=false
	phone.visible=false

	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0.4)
