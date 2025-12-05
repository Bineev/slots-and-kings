extends Node2D

class_name SlotMachine


@onready var first_column: SlotColumn = %first_column
@onready var second_column: SlotColumn = %second_column
@onready var third_column: SlotColumn = %third_column
@onready var fourth_column: SlotColumn = %fourth_column
@onready var columns: Node2D = $columns
@onready var castle_unit_factory: Node2D = %CastleUnitFactory
@onready var spin_button: Button = %spin_button
@onready var create_button: Button = %create_button

var slots : Array[Slot]
var is_need_check : bool
var is_already_created : bool

func _ready() -> void:
	SignalManager.on_spin_end.connect(create_unit)
	SignalManager.on_not_enough_food.connect(disable_create_button)
	SignalManager.on_enough_food.connect(enable_create_button)
	SignalManager.on_res_change.connect(update_buttons)
	#first_column.pre_spin()
	#second_column.pre_spin()
	#third_column.pre_spin()
	#fourth_column.pre_spin()


func _process(delta: float) -> void:
	if is_need_check:
		if check_is_spin_end():
			is_need_check = false
			if Player.check_res(1, DataManager.ResType.SPIN_TOKEN):
				spin_button.disabled = false
			create_button.disabled = false
			create_unit()


func spin_columns():
	SignalManager.spin_columns.emit()
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
	return new_slots


func create_unit():
	slots = get_active_slots()
	castle_unit_factory.choose_unit(slots)


func check_is_spin_end():
	for column in columns.get_children():
		if not column.check_spin_end():
			return false
	return true


func _on_spin_button_pressed() -> void:
	is_already_created = false
	Player.get_res(DataManager.ResType.SPIN_TOKEN, -1)
	spin_button.disabled = true
	create_button.disabled = true
	spin_columns()


func _on_create_button_pressed() -> void:
	create_button.disabled = true
	is_already_created = true
	SignalManager.on_add_unit_on_field.emit()


func enable_spin_button():
	spin_button.disabled = false


func disable_spin_button():
	spin_button.disabled = true


func disable_create_button():
	create_button.disabled = true


func enable_create_button():
	create_button.disabled = false


func update_buttons(res_type : DataManager.ResType):
	match res_type:
		DataManager.ResType.SPIN_TOKEN:
			if check_is_spin_end():
				enable_spin_button()
		DataManager.ResType.FOOD:
			if check_is_spin_end() and Player.check_res(get_parent().get_current_unit().unit_cost, DataManager.ResType.FOOD) and not is_already_created:
				enable_create_button()
