extends Node2D

@export var twitter: Node2D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_twitter"):
		
		if not UIG.phone_open:
			twitter.EnablePhone()
		else:
			twitter.DisablePhone()
		



	# doesnt work yet but dark_overlay.visible=false
		
