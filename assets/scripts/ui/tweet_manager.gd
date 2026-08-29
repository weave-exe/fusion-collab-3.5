extends Control

const tweet_scene = preload("res://assets/scenes/ui/tweet.tscn")

@export var feed_list: VBoxContainer
@export var focus_layer: Control
@export var scroll_container: ScrollContainer

var current_focus_index: int

func _ready() -> void:
	focus_layer = %FocusLayer

func bind_tweets():
	for tweet in feed_list.get_children():
		feed_list.remove_child(tweet)
		tweet.queue_free()
	
	var level_resource := LevelManager.current_level_resource
	
	for data in level_resource.tweets:
		var tweet := tweet_scene.instantiate() as Tweet
		feed_list.add_child(tweet)
		tweet.bind(data, focus_layer)

func focus_tweet(index: int):
	if feed_list == null or feed_list.get_child(index) == null:
		return
	feed_list.get_child(index).grab_focus()
	current_focus_index = index
	
func _input(event: InputEvent) -> void:
	if not UIG.twitter_open:
		return
	if !event.is_pressed():
		return
	if not (event.is_action("move_up") or event.is_action("move_down")):
		return
		
	get_viewport().set_input_as_handled()
	if event.is_echo():
		return
	
	if event.is_action_pressed("move_up"):
		_move_focus(-1)
		$UIClicker.play()
	if event.is_action_pressed("move_down"):
		_move_focus(1)
		$UIClicker.play()

func _move_focus(move: int) -> void:
	var index = clampi(current_focus_index + move, 0, feed_list.get_child_count() - 1)
	focus_tweet(index)
		
