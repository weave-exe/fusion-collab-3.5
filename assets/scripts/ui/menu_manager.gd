extends CanvasGroup

@export var level_buttons:Array[Button]
@export var phone:Node2D
@export var sliders:Array[HSlider]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in level_buttons.size():
		level_buttons[i].level_num=i+1
