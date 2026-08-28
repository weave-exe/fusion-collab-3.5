extends Node

var current_view: String
var music_vol: int
var sfx_vol: int
var bgsfx_vol: int

func _ready():
	current_view = "Gameplay"

func update_view(view):
	current_view = view
