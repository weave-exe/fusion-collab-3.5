extends Node2D

@export var phone: Node2D
@export var dark_overlay: CanvasItem
@export var off_screen: Node2D
@export var tweet_manager: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func EnablePhone():
	AudioGlobal.update_view("Twitter")
	UIG.phone_open=true
	# tween stuff
	dark_overlay.visible=true
	# turn screen on
	var phone_tween = create_tween()
	var phone_tween_visible = create_tween()
	phone_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	phone_tween_visible.tween_property(phone, "visible",true,0)
	phone_tween.tween_property(phone, "position:y",0,0.8).set_delay(0.3)
	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0)
	dark_tween.tween_property(dark_overlay, "modulate:a", 1, 1)
	# this part is for testing changing avatars
	tweet_manager.TestTweets()
	var off_screen_tween = create_tween()
	off_screen_tween.tween_property(off_screen, "modulate:a", 0, 0.2).set_delay(1.1)
		
	
	
func DisablePhone():
	AudioGlobal.update_view("Gameplay")
	UIG.phone_open=false

	var phone_tween = create_tween()
	var phone_tween_visible = create_tween()
	phone_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	phone_tween.tween_property(phone, "position:y",1200,0.7).set_delay(0.3)
	phone_tween_visible.tween_property(phone, "visible",false,0).set_delay(1.2)

	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0.5)
	
	var off_screen_tween = create_tween()
	off_screen_tween.tween_property(off_screen, "modulate:a", 1, 0.2)
