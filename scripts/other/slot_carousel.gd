extends Node2D

class_name SlotCarousel


@export var carousel_type : DataManager.CarouselType
@export var spin_speed : float = DataManager.slot_size.y
@export var initial_indexes : Vector2

var slots : Array[Slot]
var deck : Array[Slot]
var is_stopped : bool = true

func _process(delta: float) -> void:
	if not is_stopped:
		spin_slots(delta)


func initialize(copy_deck: Array[Slot]):
	deck.append_array(copy_deck)
	initialize_slots()


func initialize_slots():
	var offset = Vector2.ZERO
	slots.append(deck[initial_indexes.x])
	slots.append(deck[initial_indexes.y])
	for slot in slots:
		add_child(slot)
		slot.initialize()
		slot.position += offset
		offset += Vector2(0, DataManager.slot_size.y)


func spin():
	is_stopped = false


func stop_spin():
	is_stopped = true
	slots[0].position = Vector2.ZERO
	slots[1].position = Vector2(0, DataManager.slot_size.y)


func spin_slots(delta: float):
	for slot in slots:
		slot.position.y += (DataManager.slot_size.y * spin_speed * delta)
		if slot.position.y > DataManager.slot_size.y:
			remove_child(slot)
			slots.erase(slot)
			initial_indexes += Vector2.ONE
			slots.push_front(deck[initial_indexes.x])
			break
