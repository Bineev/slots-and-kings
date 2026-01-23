extends Node

var sound : AudioStreamPlayer
var music : AudioStreamPlayer
var main_theme1 = preload('res://sounds/2025-12-26 SLOTS&KINGS.mp3')
var main_theme2 = preload('res://sounds/2026-01-23 SNC.mp3')
var main_theme = [main_theme1, main_theme2]

var music_index : int
#const UI_HOVER : AudioStream = preload("res://sound/ui.wav")
#const ARROW = preload("res://sound/arrow.wav")
#const HIT_1 = preload("res://sound/hit1.wav")
#const MAGIC = preload("res://sound/magic.wav")
#const RANGE = preload("res://sound/range.wav")
#const SWORD = preload("res://sound/sword.wav")


func play(source : Node, stream : AudioStream):
	#if sound and sound.playing:
		#sound.stop()
	sound = AudioStreamPlayer.new()
	sound.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sound)
	sound.bus = "SFX"
	sound.stream = stream
	sound.volume_db = -25
	sound.connect("finished", sound.queue_free)
	#sound.volume_db = -15
	sound.play()


func play_local(sound_local : AudioStreamPlayer2D, stream : AudioStream):
	if is_instance_valid(sound_local):
		sound_local.volume_db = -2
		sound_local.stream = stream
		sound_local.play()


func play_ui(source : Node, stream : AudioStream):
	var sound_temp = AudioStreamPlayer.new()
	sound_temp.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sound_temp)
	sound_temp.bus = "SFX"
	sound_temp.stream = stream
	sound_temp.volume_db = -15
	sound_temp.connect("finished", sound_temp.queue_free)
	#sound.volume_db = -15
	sound_temp.stream = stream
	sound_temp.play()




func play_music(current_delay : int = 0):
	#if sound and sound.playing:
		#sound.stop()
	if music:
		music.stop()
		music.queue_free()
	music = AudioStreamPlayer.new()
	music.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(music)
	music.bus = "Music"
	if music_index == 2:
		music_index = 0
	music.stream = main_theme[music_index]
	music_index += 1
	#music.volume_db = -5
	music.connect("finished", play_music)
	music.play()
	#sound.volume_db = -15
	#get_tree().create_timer(current_delay).timeout.connect(music.play)
