extends Node2D

class_name Wave

@export var enemy_spawn_scenes : Array[PackedScene]
@export var wave_count : int
@export var time_to_next_wave : float

@onready var timer_to_next_spawn: Timer = %timer_to_next_spawn


func start_wave():
	await get_tree().process_frame
	spawn()


func spawn():
	var spawn_scene : PackedScene = enemy_spawn_scenes.pop_front()
	if not spawn_scene:
		timer_to_next_spawn.stop()
		SignalManager.on_end_wave.emit(time_to_next_wave)
		get_tree().create_timer(1).timeout.connect(destroy)
		return
	var spawn : EnemySpawn = spawn_scene.instantiate()
	add_child(spawn)
	spawn.start_spawn()
	timer_to_next_spawn.wait_time = spawn.time_to_next_spawn
	timer_to_next_spawn.start()


func destroy():
	queue_free()


func _on_timer_to_next_spawn_timeout() -> void:
	spawn()
