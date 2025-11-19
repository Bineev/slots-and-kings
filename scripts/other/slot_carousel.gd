extends Node2D

class_name SlotCarousel


@export var carousel_type : DataManager.CarouselType
@export var spin_speed : float = DataManager.slot_size.y

var slots : Array[Slot]
var next_carousel : SlotCarousel
var is_stopped : bool = true

func _process(delta: float) -> void:
	if not is_stopped:
		spin_slots(delta)

func initialize_slots():
	var offset = Vector2.ZERO
	for slot in slots:
		add_child(slot)
		slot.position += offset
		offset += Vector2(0, DataManager.slot_size.y)


func spin_slots(delta: float):
	for slot in slots:
		slot.position.y += (DataManager.slot_size.y * spin_speed * delta)
		if slot.position.y > DataManager.slot_size.y:
			remove_child(slot)
			next_carousel.add_slot(slot)
			slots.erase(slot)
			break
