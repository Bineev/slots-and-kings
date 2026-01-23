extends PanelContainer

class_name RemoverUI

@export var slot_scenes : Array[PackedScene]
@export var slots : Array[Slot]

var max_remove_count : int = 1
var is_should_start_wave : bool

@onready var slots_container: GridContainer = %slots_container
@onready var button_skip: Button = %button_skip


func _ready() -> void:
	SignalManager.on_choose_removed_slot.connect(remove_slot)


func set_slot_scenes(new_slot_scenes : Array[PackedScene]):
	slot_scenes = new_slot_scenes


func set_is_should_start_wave(new_is_should_start_wave : bool):
	is_should_start_wave = new_is_should_start_wave


func initialize():
	await get_tree().process_frame
	var wave_count : int = Player.get_current_wave_count()
	for scene in slot_scenes:
		var slot : Slot = scene.instantiate()
		if slot.slot_res.slot_name == DataManager.empty_slot_name:
			continue
		slot.set_is_on_remover_UI(true)
		# создаем контейнер для слота
		var control : Control = Control.new()
		control.custom_minimum_size = Vector2(32, 32)
		control.add_child(slot)
		slots_container.add_child(control)
		control.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.input_pickable = true
		slot.initialize()
		slot.scale = Vector2(2, 2)
		slot.position = Vector2(16, 16)
		slots.append(slot)


func close_remover_UI():
	for item in slots:
		item.is_on_remover_UI = false
	#if is_should_start_wave:
		#SignalManager.on_new_wave_start.emit()
	#get_tree().create_timer(0.5).timeout.connect(self.queue_free)
	SignalManager.on_clear_tooltips.emit()
	SignalManager.on_choose_reward_item.emit()
	self.queue_free()
	#hide()


func remove_slot(slot : Slot):
	max_remove_count -= 1
	slot.hide()
	Player.remove_slot_by_type(slot, slot.slot_type)
	if max_remove_count == 0:
		close_remover_UI()


func _on_button_skip_pressed() -> void:
	button_skip.disabled = true
	close_remover_UI()
