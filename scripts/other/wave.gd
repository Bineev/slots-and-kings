extends Node2D

class_name Wave

@export var enemy_spawn_scenes : Array[PackedScene]
@export var wave_count : int
@export var time_to_next_wave : float
@export var time_to_next_spawn : float
@export var diff_count : int

@onready var timer_to_next_spawn: Timer = %timer_to_next_spawn


func start_wave():
	await get_tree().process_frame
	spawn()


func spawn():
	var spawn_scene : PackedScene = enemy_spawn_scenes.pop_front()
	if enemy_spawn_scenes.size() == 0 and spawn_scene:
		SignalManager.on_end_wave.emit()
	if not spawn_scene:
		timer_to_next_spawn.stop()
		get_tree().create_timer(1).timeout.connect(destroy)
		return
	var spawn : EnemySpawn = spawn_scene.instantiate()
	spawn.diff_count = Player.diff_count
	add_child(spawn)
	spawn.start_spawn()
	# здесь поменять
	timer_to_next_spawn.wait_time = time_to_next_spawn
	timer_to_next_spawn.start()


func destroy():
	queue_free()


func _on_timer_to_next_spawn_timeout() -> void:
	spawn()
