extends PanelContainer

class_name UnitPreviewUI


var unit : Unit

@onready var label_unit_name: Label = %label_unit_name
@onready var rect_unit: TextureRect = %rect_unit
@onready var label_unit_tags: Label = %label_unit_tags
@onready var label_stats: RichTextLabel = %label_stats
@onready var container: HBoxContainer = %container


func _ready() -> void:
	SignalManager.on_add_unit_on_field.connect(close_UI)
	SignalManager.spin_columns.connect(close_UI)


func initialize():
	await get_tree().process_frame
	label_unit_name.text = unit.unit_name.to_upper()
	var unit_types : String
	for type in unit.unit_types:
		unit_types += DataManager.unit_types_table[type]
		unit_types += '\n'
	label_unit_tags.text = unit_types
	var unique_stats : Dictionary = unit.parse_stats()
	var unit_stats : String
	for stat in unique_stats.keys():
		var pre_string : String = '%s %s' % [stat.replace('_', ' '), unique_stats[stat]]
		if stat.contains('точность') or stat.contains('шанс') or stat.contains('уворот'):
			pre_string += '%'
		if unit.unique_stats_related[stat] == DataManager.RelateType.EQUAL:
			pre_string = '[color=#341c27]%s[/color]' % pre_string
		elif unit.unique_stats_related[stat] == DataManager.RelateType.GREATER:
			pre_string = '[color=#25562e]%s[/color]' % pre_string
		elif unit.unique_stats_related[stat] == DataManager.RelateType.LESSER:
			pre_string = '[color=#a53030]%s[/color]' % pre_string
		unit_stats += pre_string + '\n'
	label_stats.text = unit_stats


func set_unit(new_unit : Unit):
	unit = new_unit

func add_unit():
	container.add_child(unit)
	unit.position.x = 10
	unit.position.y = 8


func close_UI():
	var tween = get_tree().create_tween()
	tween.tween_property(self, 'scale', Vector2.ZERO, 0.3)
	tween.tween_callback(queue_free).set_delay(0.4)
