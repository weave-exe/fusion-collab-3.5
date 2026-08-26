extends Node2D

@export var phone: Node2D
@export var dark_overlay: CanvasItem
@export var off_screen: Node2D
@export var tweet_manager: Control
@export var menu_manager: CanvasGroup

# refactoring to just 1 tween for open/close phone
var _tween: Tween
func open_twitter():
	# only allow changing phone state if no current animation is playing
	if _is_phone_animating():
		return
		
	if not UIG.phone_open:
		enable_phone()
	if UIG.menu_open:
		disable_menu_elements()
	enable_twitter_elements()

		
func close_twitter():
	# only allow changing phone state if no current animation is playing
	if _is_phone_animating():
		return
		
	if UIG.phone_open:
		disable_phone()
	disable_twitter_elements()

	
func open_menu():
	# only allow changing phone state if no current animation is playing
	if _is_phone_animating():
		return
		
	if not UIG.phone_open:
		enable_phone()
	if UIG.twitter_open:
		disable_twitter_elements()
	enable_menu_elements()


func close_menu():
	# only allow changing phone state if no current animation is playing
	if _is_phone_animating():
		return
		
	if UIG.phone_open:
		disable_phone()
	disable_menu_elements()

# breaking ui up into smaller chunks basically
func enable_menu_elements():
	menu_manager.visible=true
	UIG.menu_open=true
	for i in menu_manager.level_buttons.size():
		menu_manager.level_buttons[i].disabled=false
	for i in menu_manager.sliders.size():
		menu_manager.sliders[i].recalc_pos()
	
func disable_menu_elements():
	menu_manager.visible=false
	UIG.menu_open=false
	for i in menu_manager.level_buttons.size():
		menu_manager.level_buttons[i].disabled=true
	
func enable_twitter_elements():
	tweet_manager.visible=true
	UIG.twitter_open=true
	tweet_manager.bind_tweets()
	
func disable_twitter_elements():
	tweet_manager.visible=false
	UIG.twitter_open=false
	
		
func enable_phone():
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
			
	
	
func disable_phone():		
	AudioGlobal.update_view("Gameplay")
	UIG.phone_open = false

	# tween animation all handled in one parallel tween
	_tween = create_tween().set_parallel(true)
	
	_tween.tween_property(phone, "position:y", 1200, 0.7).set_delay(0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	_tween.tween_property(dark_overlay, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(off_screen, "modulate:a", 1, 0.2)
	
	_tween.tween_callback(phone.hide).set_delay(1.2)
	_tween.tween_callback(dark_overlay.hide).set_delay(1.2)
	
func _is_phone_animating() -> bool:
	# only allow changing phone state if no current animation is playing
	return _tween and _tween.is_valid()
