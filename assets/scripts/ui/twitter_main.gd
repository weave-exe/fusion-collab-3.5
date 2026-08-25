extends Node2D

@export var phone: Node2D
@export var dark_overlay: CanvasItem
@export var off_screen: Node2D
@export var tweet_manager: Node2D

# refactoring to just 1 tween for open/close phone
var _tween: Tween

func enable_phone():
	# only allow changing phone state if no current animation is playing
	if _tween and _tween.is_valid():
		return

	AudioGlobal.update_view("Twitter")
	UIG.phone_open = true
	
	# initial state
	phone.position.y = 1200
	phone.visible = true
	dark_overlay.modulate.a = 0.0
	dark_overlay.visible = true

	# tween animation all handled in one parallel tween
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(dark_overlay, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(phone, "position:y", 0.0, 0.8).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_property(off_screen, "modulate:a", 0, 0.2).set_delay(1.1)
	
	# this part is for testing changing avatars
	tweet_manager.bind_tweets()
		
	
	
func disable_phone():
	# only allow changing phone state if no current animation is playing
	if _tween and _tween.is_valid():
		return
		
	AudioGlobal.update_view("Gameplay")
	UIG.phone_open = false

	# tween animation all handled in one parallel tween
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(phone, "position:y", 1200, 0.7).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_property(dark_overlay, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(off_screen, "modulate:a", 1, 0.2)
	
	_tween.tween_callback(phone.hide).set_delay(1.2)
	_tween.tween_callback(dark_overlay.hide).set_delay(1.2)
	
