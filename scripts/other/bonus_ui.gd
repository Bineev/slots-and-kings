extends PanelContainer

class_name BonusUI


@export var bonus_name : String
@export var bonus_count : int

@onready var label_bonus: Label = %label_bonus


func set_bonus_name(new_bonus_name : String):
	bonus_name = new_bonus_name


func set_bonus_count(new_bonus_count : int):
	bonus_count = new_bonus_count


func initialize():
	await get_tree().process_frame
	var current_locale : String = TranslationServer.get_locale()
	var bonus_prefix : String
	match current_locale:
		'en_US':
			bonus_prefix = 'Astrologers proclaim the week of the %s. The number of summonable %s has been increased by %d'
		'ru_RU':
			bonus_prefix = 'Астрологи объявили неделю %s. Количество призываемых %s увеличено на %d'
	label_bonus.text = bonus_prefix % [tr(bonus_name), tr(bonus_name), bonus_count]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		queue_free()
