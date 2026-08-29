extends AudioStreamPlayer

const ow_melody = 0
const ow_harm1 = 1
const ow_harm2 = 2
const ow_perc = 3
const ow_bass = 4
const ow_pers = 5
const ow_water = 6

var interactive_stream: AudioStreamInteractive
var sync_stream: AudioStreamSynchronized

func _ready() -> void:
	interactive_stream = stream as AudioStreamInteractive
	if interactive_stream:
		sync_stream = interactive_stream.get_clip_stream(0)
	LevelManager.connect("layer_array",set_levels)
	play()

func _process(delta: float) -> void:
	pass

var tween: Tween

func set_levels(layers: Array):
	if not sync_stream:
		return
		
	_kill_tween()
	tween = create_tween().set_parallel(true)
	for j in layers.size():
		if layers[j] == true:
			tween.tween_method( 
				func(volume): sync_stream.set_sync_stream_volume(j, volume), 
				sync_stream.get_sync_stream_volume(j), 
				0, 
				2
			)
		else:
			tween.tween_method( 
				func(volume): sync_stream.set_sync_stream_volume(j, volume), 
				sync_stream.get_sync_stream_volume(j), 
				-80, 
				2
			)

func _kill_tween():
	if tween and tween.is_valid():
		tween.kill()
