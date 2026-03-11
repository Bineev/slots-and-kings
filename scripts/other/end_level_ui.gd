extends PanelContainer

class_name EndLevelUI


@export var stylebox_tooltip : StyleBox = preload("res://styles/panel_gold.tres")
@export var font_tooltip : Font = preload("res://fonts/DigitalPixelV124-Regular.otf")
@export var win_text : String
@export var loose_text : String
@export var units_lost_text : String
@export var units_destroyed_text : String
@export var phdamage_text : String
@export var mdamage_text : String
@export var pdamage_text : String
@export var hdamage_text : String
@export var castle_strengthr_text : String
@export var castle_strengthl_text : String
@export var gold_spent_text : String
@export var token_spent_text : String
@export var food_spent_text : String
@export var crystall_spent_text : String
@export var soulsearned_text : String

@onready var stats_header_label: Label = %stats_header_label
@onready var stats_unit_destroyed: Label = %stats_unit_destroyed
@onready var stats_unit_lost: Label = %stats_unit_lost
@onready var stats_phdamage: Label = %stats_phdamage
@onready var stats_mdamage: Label = %stats_mdamage
@onready var stats_pdamage: Label = %stats_pdamage
@onready var stats_hdamage: Label = %stats_hdamage
@onready var stats_castlehplost: Label = %stats_castlehplost
@onready var stats_castlehprest: Label = %stats_castlehprest
@onready var stats_goldlost: Label = %stats_goldlost
@onready var stats_tokenlost: Label = %stats_tokenlost
@onready var stats_foodlost: Label = %stats_foodlost
@onready var stats_crystalllost: Label = %stats_crystalllost
@onready var stats_soulsearned: Label = %stats_soulsearned
@onready var button_complete: Button = %button_complete
@onready var label_res_souls: Label = %label_res_souls
@onready var label_souls_earned: Label = %label_souls_earned
@onready var rewards_container: HBoxContainer = %rewards_container
@onready var label_open_stats: Label = %label_open_stats
@onready var stats_container: VBoxContainer = %stats_container


func initialize():
	await get_tree().process_frame
	var stats : Dictionary = Player.get_level_stats()
	if Player.get_health() > 0:
		stats_header_label.text = tr(win_text)
		SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.SHOW_REWARDS])
	else:
		SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.START_WAVE])
		stats_header_label.text = tr(loose_text)
	stats_unit_destroyed.text = tr(units_destroyed_text) + ' : ' + str(stats[DataManager.LevelStats.UNITS_DESTROYED])
	stats_unit_lost.text = tr(units_lost_text) + ' : ' + str(stats[DataManager.LevelStats.UNITS_LOST])
	stats_phdamage.text = tr(phdamage_text) + ' : ' + str(stats[DataManager.LevelStats.PHYS_DAMAGE_COUNT])
	stats_mdamage.text = tr(mdamage_text) + ' : ' + str(stats[DataManager.LevelStats.MAGE_DAMAGE_COUNT])
	stats_pdamage.text = tr(pdamage_text) + ' : ' + str(stats[DataManager.LevelStats.PURE_DAMAGE_COUNT])
	stats_hdamage.text = tr(hdamage_text) + ' : ' + str(stats[DataManager.LevelStats.HEROES_DAMAGE_DEALT])
	stats_castlehplost.text = tr(castle_strengthl_text) + ' : ' + str(stats[DataManager.LevelStats.FORTRESS_HEALTH_LOST])
	stats_castlehprest.text = tr(castle_strengthr_text) + ' : ' + str(stats[DataManager.LevelStats.FORTRESS_HEALTH_RESTORED])
	stats_goldlost.text = tr(gold_spent_text) + ' : ' + str(abs(stats[DataManager.LevelStats.GOLD_LOST]))
	stats_tokenlost.text = tr(token_spent_text) + ' : ' + str(abs(stats[DataManager.LevelStats.TOKEN_LOST]))
	stats_foodlost.text = tr(food_spent_text) + ' : ' + str(abs(stats[DataManager.LevelStats.FOOD_LOST]))
	stats_crystalllost.text = tr(crystall_spent_text) + ' : ' + str(abs(stats[DataManager.LevelStats.CRYSTALLS_LOST]))
	label_res_souls.text = str(Player.current_souls)
	for reward in Player.level.rewards:
		var slot : Slot = Player.create_slot_scene(reward).instantiate()
		#slot.initialize()
		var texture_rect : TextureRect = TextureRect.new()
		texture_rect.texture = slot.slot_res.slot_sprite
		texture_rect.tooltip_text = slot.slot_res.slot_name
		
		var new_theme = Theme.new()
		var sb = stylebox_tooltip.duplicate()
		sb.set_content_margin_all(10)
		new_theme.set_stylebox('panel', 'TooltipPanel', sb)
		new_theme.set_font('font', 'TooltipLabel', font_tooltip)
		new_theme.set_font_size('font_size', 'TooltipLabel', 8)
		new_theme.set_color('font_color', 'TooltipLabel', Color8(52, 28, 39, 255))
		texture_rect.theme = new_theme
		rewards_container.add_child(texture_rect)


func _on_button_complete_pressed() -> void:
	button_complete.disabled
	hide()
	if Player.get_health() > 0:
		GameManager.win()
	else:
		GameManager.loose()


func _on_label_open_stats_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				label_open_stats.hide()
				stats_container.show()
