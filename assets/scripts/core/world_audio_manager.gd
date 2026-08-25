extends Node

@export var bg_music_player: AudioStreamPlayer
var current_view: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_view = AudioGlobal.current_view

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_view != AudioGlobal.current_view:
		current_view = AudioGlobal.current_view
		update_music_for_scene()
		
func update_music_for_scene():
	var current_view_music = str(current_view + "Music")
	bg_music_player["parameters/switch_to_clip"] = current_view_music
	
func handle_sfx():
	pass
