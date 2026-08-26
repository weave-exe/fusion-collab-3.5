extends Control

const tweet_scene = preload("res://assets/scenes/ui/tweet.tscn")

@export var feed_list: VBoxContainer
@export var tweet_data: Array[TweetData]

func bind_tweets():
	for tweet in feed_list.get_children():
		feed_list.remove_child(tweet)
		tweet.queue_free()
	for data in tweet_data:
		var tweet := tweet_scene.instantiate() as Tweet
		feed_list.add_child(tweet)
		tweet.bind(data)
	feed_list.get_child(0).grab_focus()
