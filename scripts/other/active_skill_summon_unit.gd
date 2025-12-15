extends ActiveSkillSummon

class_name ActiveSkillSummonUnit


@export var unit_slots_scenes : Array[PackedScene]

var slots : Array[Slot]
var unit : Unit


func create_entity():
	var factory : UnitFactory = Player.get_unit_factory()
	var slots : Array[Slot]
	for slot_scene in unit_slots_scenes:
		var slot : Slot = slot_scene.instantiate()
		add_child(slot)
		slot.hide()
		slot.initialize()
		slots.append(slot)
	await get_tree().process_frame
	unit = factory.get_unit(slots)
	SignalManager.on_add_unit_from_skill.emit(unit, get_global_mouse_position())
	get_tree().create_timer(1).timeout.connect(remove_slots)


func deactivate():
	if unit and is_instance_valid(unit):
		unit.get_damage(1000000, skill_owner)


func remove_slots():
	for slot in slots:
		slot.queue_free()
