extends Node2D

class_name EnemySpawn


@export var unit_family : DataManager.UnitFamily
@export var unit_reses : Array[Resource]
@export var upgrades_reses : Array[Resource]
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
	var unit_res : Resource = unit_reses.pop_front()
	if not unit_res:
		unit_spawn_timer.stop()
		get_tree().create_timer(0.5).timeout.connect(destroy)
		return
	var unit_slot_scene : PackedScene = Player.create_slot_scene(unit_res)
	var slots : Array[Slot]
	var slot : Slot = unit_slot_scene.instantiate()
	add_child(slot)
	slot.visible = false
	slot.initialize()
	slots.append(slot)
	for res in upgrades_reses:
		var slot_scene : PackedScene = Player.create_slot_scene(res)
		var upgrade_slot : Slot = slot_scene.instantiate()
		upgrade_slot.hide()
		add_child(upgrade_slot)
		upgrade_slot.initialize()
		slots.append(upgrade_slot)
	unit_factory.choose_unit(slots)


func destroy():
	queue_free()
