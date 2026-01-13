extends Node


#const UI_HOVER : AudioStream = preload("res://sound/ui.wav")
#const ARROW = preload("res://sound/arrow.wav")
#const HIT_1 = preload("res://sound/hit1.wav")
#const MAGIC = preload("res://sound/magic.wav")
#const RANGE = preload("res://sound/range.wav")
#const SWORD = preload("res://sound/sword.wav")


func play(source : Node, stream : AudioStream):
	var sound : AudioStreamPlayer = AudioStreamPlayer.new()
	source.add_child(sound)
	sound.bus = "SFX"
	sound.stream = stream
	sound.volume_db = -20
	sound.connect("finished", sound.queue_free)
	#sound.volume_db = -15
	sound.stream = stream
	sound.play()
		
func play_local(sound_local : AudioStreamPlayer2D, stream : AudioStream):
	if is_instance_valid(sound_local):
		sound_local.volume_db = -15
		sound_local.stream = stream
		sound_local.play()
