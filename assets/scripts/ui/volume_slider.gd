extends HSlider

@export var bus:String


func recalc_pos():
	value=db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus)))


func _on_drag_started() -> void:
	# sounds will go here
	pass
	


func _on_value_changed(_value) -> void:

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),linear_to_db(value))
	AudioGlobal.save_audio()
