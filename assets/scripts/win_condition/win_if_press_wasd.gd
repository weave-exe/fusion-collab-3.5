extends Node

@export var timer: Timer

func _input(event: InputEvent) -> void:
	if not UIG.phone_open:
		if not LevelManager.level_completed:
			if event.is_action_pressed("move_up"):
				timer.start()
			elif event.is_action_pressed("move_left"):
				timer.start()
			elif event.is_action_pressed("move_right"):
				timer.start()
			elif event.is_action_pressed("move_down"):
				timer.start()

		


func _on_timer_timeout() -> void:
	SignalBus.level_won.emit()
