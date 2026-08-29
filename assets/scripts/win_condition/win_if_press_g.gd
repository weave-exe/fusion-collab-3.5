extends Node


func _input(event: InputEvent) -> void:

	if event.is_action_pressed("secret_win"):
		if not UIG.phone_open:
			SignalBus.level_won.emit()
		
