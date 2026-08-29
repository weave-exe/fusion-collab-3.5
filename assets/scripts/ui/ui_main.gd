extends Node2D

@export var phone: Node2D


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if LevelManager.is_input_blocked():
		return
	if event.is_action_pressed("open_twitter"):
		
		if not UIG.twitter_open:
			phone.open_twitter()
		else:
			phone.close_twitter()	
	if event.is_action_pressed("pause"):
		if not UIG.menu_open:
			phone.open_menu()
		else:
			phone.close_menu()	

			

		



		
