extends Node2D

class_name SlotMachine


@export var style_box_full : StyleBox
@export var style_box_not_full : StyleBox

@onready var first_column: SlotColumn = %first_column
@onready var second_column: SlotColumn = %second_column
@onready var third_column: SlotColumn = %third_column
@onready var fourth_column: SlotColumn = %fourth_column
@onready var fifth_column: SlotColumn = %fifth_column
@onready var columns: Node2D = $columns
@onready var castle_unit_factory: Node2D = %CastleUnitFactory
@onready var spin_button: Button = %spin_button
@onready var create_button: Button = %create_button
@onready var bar_can_swap: ProgressBar = %bar_can_swap
@onready var timer_can_swap: Timer = %timer_can_swap
@onready var label_bonus: Label = %label_bonus
@onready var buttons_container: MarginContainer = %buttons_container


var slots : Array[Slot]
var is_need_check : bool
var is_already_created : bool
var current_active_slots : Array[Slot]

func _ready() -> void:
	SignalManager.on_spin_end.connect(create_unit)
	SignalManager.on_not_enough_food.connect(disable_create_button_without_hide)
	SignalManager.on_enough_food.connect(enable_create_button_without_hide)
	SignalManager.on_res_change.connect(update_buttons)
	SignalManager.on_swap_done.connect(clear_bar_can_swap)
	SignalManager.on_update_bonus_week.connect(update_bonus_week)
	await get_tree().process_frame
	#Player.set_unit_factory(castle_unit_factory)
	initialize()
	#first_column.pre_spin()
	#second_column.pre_spin()
	#third_column.pre_spin()
	#fourth_column.pre_spin()


func disable_create_button_without_hide():
	create_button.disabled = true


func enable_create_button_without_hide():
	create_button.disabled = false


func _process(delta: float) -> void:
	if is_need_check:
		if check_is_spin_end():
			is_need_check = false
			if Player.check_res(1, DataManager.ResType.SPIN_TOKEN):
				spin_button.disabled = false
			create_button.disabled = false
			create_button.show()
			create_unit()


func initialize():
	await get_tree().process_frame
	buttons_container.size = Vector2.ZERO
	timer_can_swap.wait_time = Player.get_can_swap_time()
	timer_can_swap.start()


func spin_columns():
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SLOTS_START])
	SignalManager.spin_columns.emit()
	SignalManager.on_clear_tooltips.emit()
	first_column.set_carousels_spin_start()
	second_column.set_carousels_spin_start()
	third_column.set_carousels_spin_start()
	fourth_column.set_carousels_spin_start()
	is_need_check = true


func get_active_slots():
	var new_slots : Array[Slot]
	var unit_slot = third_column.get_active_slots()
	var upgrade_slots = second_column.get_active_slots() + fourth_column.get_active_slots()
	var perc_slots = first_column.get_active_slots()
	new_slots.append_array(unit_slot)
	new_slots.append_array(upgrade_slots)
	new_slots.append_array(perc_slots)
	#for slot in new_slots:
		#slot.set_collision_layer_value(11, true)
		#slot.monitorable = true
	return new_slots


func create_unit():
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SLOTS_END])
	if slots.size() > 0:
		for slot in slots:
			slot.stop_highlight()
	slots = get_active_slots()
	for slot in slots:
		if tr(slot.slot_name) != DataManager.empty_slot_name and tr(slot.slot_name) != DataManager.empty_slot_name_en:
			slot.highlight_slot()
	var units_count : int = slots.filter(func(slot : Slot): return slot.slot_type == DataManager.SlotType.UNIT).size()
	var unit_slot : Slot = slots[0]
	Player.set_units_count_for_next_create(units_count)
	castle_unit_factory.choose_unit(slots.slice(0, 1) + slots.slice(units_count))

#
#func dehighlight_spots():
	#for slot in current_active_slots:
		#slot.stop_highlight()


func check_is_spin_end():
	for column in columns.get_children():
		if not column.check_spin_end():
			return false
	return true


func _on_spin_button_pressed() -> void:
	press_spin_button()


func press_spin_button():
	is_already_created = false
	Player.get_res(DataManager.ResType.SPIN_TOKEN, -1)
	spin_button.disabled = true
	create_button.disabled = true
	create_button.hide()
	spin_columns()


func _on_create_button_pressed() -> void:
	press_create_button()


func press_create_button():
	create_button.disabled = true
	create_button.hide()
	is_already_created = true
	SignalManager.on_add_unit_on_field.emit()
	SignalManager.on_cant_swap.emit()


func enable_spin_button():
	spin_button.disabled = false


func disable_spin_button():
	spin_button.disabled = true


func disable_create_button():
	create_button.disabled = true
	create_button.hide()


func enable_create_button():
	if not is_already_created:
		create_button.disabled = false
		create_button.show()


func update_buttons(res_type : DataManager.ResType):
	match res_type:
		DataManager.ResType.SPIN_TOKEN:
			if check_is_spin_end():
				enable_spin_button()
		DataManager.ResType.FOOD:
			if check_is_spin_end() and not is_already_created and get_parent().get_current_unit() and Player.check_res(get_parent().get_current_unit().unit_cost, DataManager.ResType.FOOD):
				enable_create_button()


func get_factory():
	return castle_unit_factory


func _on_timer_can_swap_timeout() -> void:
	bar_can_swap.value += 1
	if bar_can_swap.value == bar_can_swap.max_value:
		timer_can_swap.stop()
		bar_can_swap.add_theme_stylebox_override("fill", style_box_full)
		Player.set_is_can_swap(true)


func clear_bar_can_swap():
	create_unit()
	bar_can_swap.value = 0
	bar_can_swap.add_theme_stylebox_override("fill", style_box_not_full)
	timer_can_swap.start()


func swap_down():
	var target_slot : Slot = third_column.slot_carousel_top.slots[1]
	target_slot.before_can_swap_position = target_slot.global_position
	var change_slot : Slot = third_column.slot_carousel_mid.slots[1]
	if Player.is_can_swap:
		target_slot.current_swap_slots.append(change_slot)
		target_slot.move_slots()
		#change_slot.global_position = target_slot.before_can_swap_position
		change_slot.z_index = 100


func swap_up():
	var target_slot : Slot = third_column.slot_carousel_bot.slots[1]
	target_slot.before_can_swap_position = target_slot.global_position
	var change_slot : Slot = third_column.slot_carousel_mid.slots[1]
	if Player.is_can_swap:
		target_slot.current_swap_slots.append(change_slot)
		target_slot.move_slots()
		#change_slot.global_position = target_slot.before_can_swap_position
		change_slot.z_index = 100


func update_bonus_week(slot_name : String):
	var current_locale : String = TranslationServer.get_locale()
	var bonus_prefix : String
	match current_locale:
		'en_US':
			bonus_prefix = 'Week: %s'
		'ru_RU':
			bonus_prefix = 'Неделя: %s'
	label_bonus.text = bonus_prefix % tr(slot_name)
