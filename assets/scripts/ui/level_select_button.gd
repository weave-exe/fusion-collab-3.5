extends Button

@export var level_num: int
@export var richtext:RichTextLabel
@onready var menu_manager: CanvasGroup


func _ready():
	richtext.text="[center]"+str(level_num)+"[/center]"
	menu_manager = %MenuManager


func _on_pressed() -> void:
	# sound could be added here
	pass
	


func _on_button_up() -> void:
	LevelManager.load_level(level_num)
	menu_manager.phone.close_menu()

	pass # Replace with function body.
