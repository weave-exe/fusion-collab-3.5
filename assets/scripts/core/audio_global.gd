extends Node

var current_view: String
var music_vol: int
var sfx_vol: int
var bgsfx_vol: int

func _ready():
	current_view = "Gameplay"

func update_view(view):
	current_view = view
	print(current_view)
	
func sfx_handle(name):
	#can be used later if we decide on a different means of sfx handling
	pass
