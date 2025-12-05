extends Node2D

class_name EnemySpawn


@export var unit_family : DataManager.UnitFamily
@export var unit_slots_scenes : Array[PackedScene]
@export var upgrades_scenes : Array[PackedScene]
@export var unit_factory_scene : PackedScene
@export var spawn_weight : int
@export var time_to_next_spawn : int
@export var time_between_units : float

var unit_factory : UnitFactory

@onready var unit_spawn_timer: Timer = %unit_spawn_timer


func start_spawn():
	await get_tree().process_frame
	unit_factory = unit_factory_scene.instantiate()
	unit_factory.set_unit_owner(DataManager.UnitOwner.ENEMY)
	SignalManager.on_start_spawn.emit()
	unit_spawn_timer.wait_time = time_between_units
	unit_spawn_timer.start()


func _on_unit_spawn_timer_timeout() -> void:
	spawn_unit()


func spawn_unit():
	var slots_scene : PackedScene = unit_slots_scenes.pop_front()
	if not slots_scene:
		unit_spawn_timer.stop()
		get_tree().create_timer(0.5).timeout.connect(destroy)
		return
	var slots : Array[Slot]
	var slot : Slot = slots_scene.instantiate()
	add_child(slot)
	slot.visible = false
	slot.initialize()
	slots.append(slot)
	for scene in upgrades_scenes:
		var upgrade_slot : Slot = scene.instantiate()
		upgrade_slot.initialize()
		slots.append(upgrade_slot)
	unit_factory.choose_unit(slots)


func destroy():
	queue_free()
