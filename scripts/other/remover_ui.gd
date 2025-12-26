extends PanelContainer

class_name RemoverUI

@export var slot_scenes : Array[PackedScene]
@export var slots : Array[Slot]

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
	if is_should_start_wave:
		SignalManager.on_new_wave_start.emit()
	#get_tree().create_timer(0.5).timeout.connect(self.queue_free)
	self.queue_free()
	SignalManager.on_clear_tooltips.emit()
	#hide()


func remove_slot(slot : Slot):
	slot.hide()
	for item in slots:
		item.is_on_remover_UI = false
	Player.remove_slot_by_type(slot, slot.slot_type)
	close_remover_UI()


func _on_button_skip_pressed() -> void:
	button_skip.disabled = true
	close_remover_UI()
