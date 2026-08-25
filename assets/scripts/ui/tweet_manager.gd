extends Node2D

@export var tweets: Array[Tweet]
@export var tweet_data: Array[TweetData]

func bind_tweets():
	for i in tweet_data.size():
		if i < tweets.size():
			tweets[i].bind(tweet_data[i])
