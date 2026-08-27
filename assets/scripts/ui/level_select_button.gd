extends Button

@export var level_num: int
@export var richtext:RichTextLabel
@onready var menu_manager: CanvasGroup
@export var sound: AudioStreamPlayer2D

func initialize(unlocked:bool):
	if unlocked:
		richtext.visible=true
		disabled=false
	else:
		richtext.visible=false
		disabled=true

func _ready():
	richtext.text="[center]"+str(level_num)+"[/center]"
	menu_manager = %MenuManager


func _on_pressed() -> void:
	sound.play()
	pass
	


func _on_button_up() -> void:
	LevelManager.load_level(level_num)
	menu_manager.phone.close_menu()

	pass # Replace with function body.
