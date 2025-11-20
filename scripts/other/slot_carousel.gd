extends Node2D

class_name SlotCarousel


@export var carousel_type : DataManager.CarouselType
@export var initial_indexes : Vector2

var spin_curve : Curve
var spin_progress : float = 0
var slots : Array[Slot]
var deck : Array[Slot]
var is_stopped : bool = true
var spin_speed : float
var spin_time : float

func _ready() -> void:
	spin_speed = DataManager.default_spin_speed


func _process(delta: float) -> void:
	if not is_stopped:
		spin_progress += delta / spin_time
		if spin_progress >= 1:
			is_stopped = true
			spin_speed = DataManager.default_spin_speed
			spin_progress = 0
			after_spin()
		else:
			var curved_value = spin_curve.sample(spin_progress)
			spin_speed = DataManager.default_spin_speed + DataManager.default_spin_speed * curved_value * 70
			spin_slots()


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


func spin_slots():
	for slot in slots:
		slot.position.y += spin_speed
	if slots[0].position.y > DataManager.slot_size.y:
		remove_child(slots[1])
		slots.erase(slots[1])
		initial_indexes -= Vector2.ONE
		if initial_indexes.x < 0:
			initial_indexes = Vector2(deck.size() - 1, 0)
		if initial_indexes.y < 0:
			initial_indexes = Vector2(deck.size() - 2, deck.size() - 1)
		slots.push_front(deck[initial_indexes.x])
		add_child(slots[0])
		slots[0].initialize()
		slots[0].position.y = slots[1].position.y - DataManager.slot_size.y


func set_default_position_for_slots():
	slots[0].position = Vector2.ZERO
	slots[1].position = Vector2(0, DataManager.slot_size.y)


func set_new_position_for_slots():
	remove_child(slots[1])
	slots.erase(slots[1])
	initial_indexes -= Vector2.ONE
	if initial_indexes.x < 0:
		initial_indexes = Vector2(deck.size() - 1, 0)
	if initial_indexes.y < 0:
		initial_indexes = Vector2(deck.size() - 2, deck.size() - 1)
	slots.push_front(deck[initial_indexes.x])
	add_child(slots[0])
	slots[0].initialize()
	set_default_position_for_slots()

func after_spin():
	var tween = get_tree().create_tween()
	if slots[0].position.y < DataManager.slot_size.y / 2:
		tween.tween_callback(set_default_position_for_slots).set_delay(0.5)
	else:
		tween.tween_callback(set_new_position_for_slots).set_delay(0.5)
