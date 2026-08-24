extends Node2D

@export var phone: Node2D
@export var dark_overlay: CanvasItem
@onready var twitter_open: bool=false
# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_twitter"):
		print(phone.visible)
		if not twitter_open:
			EnableTwitter()
		else:
			DisableTwitter()
		
		
func EnableTwitter():
	twitter_open=true
	phone.visible=true
	# tween stuff
	dark_overlay.visible=true
	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0)
	dark_tween.tween_property(dark_overlay, "modulate:a", 1, 0.7)

	
	


func DisableTwitter():
	twitter_open=false
	phone.visible=false
	var dark_tween = create_tween()
	dark_tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	dark_tween.tween_property(dark_overlay, "modulate:a", 0, 0.4)
	# doesnt work yet but dark_overlay.visible=false
		
