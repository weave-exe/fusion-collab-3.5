extends Node

var current_view: String
var music_vol: int
var sfx_vol: int
var bgsfx_vol: int

const save_path := "user://audiodata.cfg"

func _ready():
	current_view = "Gameplay"
	load_audio()

func update_view(view):
	current_view = view
	load_audio()


func save_audio() -> void:
	var config := ConfigFile.new()
	for i in AudioServer.bus_count:
		config.set_value("audio", AudioServer.get_bus_name(i), AudioServer.get_bus_volume_db(i))
	config.save(save_path)
	
func load_audio() -> void:
	var config := ConfigFile.new()
	var err := config.load(save_path)
	if err != OK:
		return
	for i in AudioServer.bus_count:
		var loaded_volume = config.get_value("audio", AudioServer.get_bus_name(i), null)
		if loaded_volume != null:
			AudioServer.set_bus_volume_db(i,loaded_volume)
