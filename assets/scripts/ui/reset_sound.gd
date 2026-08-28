extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("level_resetting",play_sound)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_sound():
	play()
