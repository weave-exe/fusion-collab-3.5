extends Control

const tweet_scene = preload("res://assets/scenes/ui/tweet.tscn")

@export var feed_list: VBoxContainer

func bind_tweets():
	for tweet in feed_list.get_children():
		feed_list.remove_child(tweet)
		tweet.queue_free()
	
	var level_resource := LevelManager.current_level_resource
	
	for data in level_resource.tweets:
		var tweet := tweet_scene.instantiate() as Tweet
		feed_list.add_child(tweet)
		tweet.bind(data)
	feed_list.get_child(0).grab_focus()
