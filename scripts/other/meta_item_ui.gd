extends PanelContainer

class_name MetaItemUI

@export var stylebox_tooltip : StyleBox = preload("res://styles/panel_gold.tres")
@export var font_tooltip : Font = preload("res://fonts/DigitalPixelV124-Regular.otf")
@export var item_texture : Texture2D
@export var item_name : String
@export var item_desc : String
@export var is_increment : bool = true
@export var item_level : int = 1
@export var item_default_value : float
@export var item_value : float
@export var item_max_value : float
@export var item_up_value : float
@export var item_up_cost : float
@export var item_up_default_cost : float
@export var meta_type : DataManager.MetaType
@export var meta_stats : Dictionary[DataManager.MetaType, float]

@onready var button_buy: Button = %button_buy
@onready var meta_item_texture: TextureRect = %meta_item_texture


func _ready() -> void:
	SignalManager.on_buy_meta.connect(disable_if_not_enough_souls)


func initialize():
	await get_tree().process_frame
	meta_stats = Player.get_meta_stats()
	for meta_stat in meta_stats.keys():
		if meta_type == meta_stat:
			item_value = meta_stats[meta_stat]
	if item_value == item_default_value:
		item_level = 1
	else:
		item_level = 1 + abs((item_value - item_default_value) / item_up_value)
	item_up_cost = item_up_default_cost * item_level
	button_buy.text = str(int(item_up_cost))
	if item_value == item_max_value:
		button_buy.text = 'max'
	tooltip_text = tr(item_desc)
	var new_theme = Theme.new()
	var sb = stylebox_tooltip.duplicate()
	sb.set_content_margin_all(10)
	new_theme.set_stylebox('panel', 'TooltipPanel', sb)
	new_theme.set_font('font', 'TooltipLabel', font_tooltip)
	new_theme.set_font_size('font_size', 'TooltipLabel', 8)
	new_theme.set_color('font_color', 'TooltipLabel', Color8(52, 28, 39, 255))
	#var stylebox = new_theme.get_theme_stylebox('normal')
	theme = new_theme
	meta_item_texture.texture = item_texture
	disable_if_not_enough_souls()


func change_meta_stat():
	Player.change_meta_stat(meta_type, item_up_value)


func _on_button_buy_pressed() -> void:
	if Player.check_res(item_up_cost, DataManager.ResType.SOULS):
		Player.get_res(DataManager.ResType.SOULS, -item_up_cost)
		button_buy.disabled = true
		change_meta_stat()
		initialize()
		button_buy.disabled = false
		SignalManager.on_buy_meta.emit()


func disable_if_not_enough_souls():
	if Player.current_souls < item_up_cost:
		button_buy.disabled = true
	else:
		button_buy.disabled = false
