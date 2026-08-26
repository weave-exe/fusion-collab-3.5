extends SubViewportContainer

@onready var zoom:int=3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.connect("level_loaded",SetZoom)
	
func SetZoom(_level, zoom):
	stretch_shrink=zoom
