extends Node2D

@export var tweets: Array[Node2D]

func TestTweets():
	for i in tweets.size():
		tweets[i].avatar.region_rect=Rect2(i*UIG.avatar_size,0*UIG.avatar_size,UIG.avatar_size,UIG.avatar_size)
