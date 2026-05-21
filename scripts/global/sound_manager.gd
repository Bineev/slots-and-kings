extends Node


var music_player : AudioStreamPlayer

# Заполняйте эти массивы в инспекторе Godot (mp3/wav)
@export var gameplay_playlist : Array[AudioStream] = [
	preload("res://sounds/piece.mp3"),
	preload("res://sounds/fight2.mp3"),
	preload("res://sounds/piece2.mp3"),
	#preload("res://sounds/battle_epic.mp3"),
	preload("res://sounds/piece3.mp3"),
]
@export var menu_theme : AudioStream = preload("res://sounds/menu.mp3")

var played_streams : Array[AudioStreamPlayer] = []
var remaining_tracks : Array[AudioStream] = []
var is_in_gameplay : bool = false


func play(source : Node, stream : AudioStream):
	# Контроль звуковой каши
	if played_streams.size() >= DataManager.max_sounds:
		 # Опционально: можно удалять самый старый звук вместо игнорирования нового
		var oldest = played_streams.pop_front()
		if is_instance_valid(oldest): oldest.queue_free()
		#return
		
	var sound = AudioStreamPlayer.new()
	sound.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sound)
	played_streams.append(sound)
	
	sound.bus = "SFX"
	sound.stream = stream
	sound.volume_db = -25
	
	# Передаем конкретный плеер в функцию удаления
	sound.connect("finished", erase_finished_sound.bind(sound))
	sound.play()



func _ready():
	# При запуске игры сразу включаем музыку меню
	play_menu_music()


# --- СЕКЦИЯ МУЗЫКИ (ЕДИНЫЙ ПЛЕЙЛИСТ) ---

# 1. Вызывать при загрузке главного меню (или при выходе из игры в меню)
func play_menu_music():
	is_in_gameplay = false
	_stop_music_player()
	
	if not menu_theme:
		print("Внимание: Забыли назначить menu_theme в инспекторе!")
		return
		
	music_player = AudioStreamPlayer.new()
	music_player.stream = menu_theme
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = "Music"
	music_player.volume_db = -5
	
	# Музыка меню обычно одна, пусть зацикливается сама (если не включен Loop в импорте)
	music_player.connect("finished", music_player.play)
	
	add_child(music_player)
	music_player.play()


# 2. Вызывать ОДИН РАЗ, когда игрок нажимает «Играть» и заходит на уровень
func start_gameplay_playlist(fade_duration: float = 1.0):
	is_in_gameplay = true
	
	if is_instance_valid(music_player) and music_player.playing:
		# Плавно глушим меню и запускаем плейлист уровня
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_duration)
		tween.finished.connect(func():
			_stop_music_player()
			_play_next_random_track()
		)
	else:
		_play_next_random_track()


# Внутренний метод: выбирает случайный трек и следит за его окончанием
func _play_next_random_track():
	if not is_in_gameplay: return
	_stop_music_player()
	
	if gameplay_playlist.is_empty():
		print("Внимание: Плейлист геймплея пуст!")
		return
		
	# Если все треки из пула отыграли, заполняем его заново для нового круга
	if remaining_tracks.is_empty():
		remaining_tracks = gameplay_playlist.duplicate()
		remaining_tracks.shuffle() # Перемешиваем случайным образом
		
	# Берем первый трек из перемешанного списка и удаляем его оттуда
	var next_track = remaining_tracks.pop_front()
	
	music_player = AudioStreamPlayer.new()
	music_player.stream = next_track
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.bus = "Music"
	music_player.volume_db = -5
	
	# Когда трек доиграет до конца, автоматически вызовется эта же функция и включит СЛЕДУЮЩИЙ трек
	music_player.connect("finished", _play_next_random_track)
	
	add_child(music_player)
	music_player.play()


func _stop_music_player():
	if is_instance_valid(music_player):
		music_player.queue_free()



func erase_finished_sound(sound_to_erase : AudioStreamPlayer):
	played_streams.erase(sound_to_erase)
	if is_instance_valid(sound_to_erase):
		sound_to_erase.queue_free()

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
	sound_temp.play()
