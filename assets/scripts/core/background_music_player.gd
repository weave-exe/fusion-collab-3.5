extends AudioStreamPlayer

const ow_melody = 0
const ow_harm1 = 1
const ow_harm2 = 2
const ow_perc = 3
const ow_bass = 4

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

func set_levels(layers: Array):
	if not sync_stream:
		return
		
	for j in layers.size():
		if layers[j] == true:
			sync_stream.set_sync_stream_volume(j, 0)
		else:
			sync_stream.set_sync_stream_volume(j, -80)

		
