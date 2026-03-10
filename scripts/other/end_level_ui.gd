extends PanelContainer

class_name EndLevelUI


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


func initialize():
	await get_tree().process_frame
	var stats : Dictionary = Player.get_level_stats()
	if Player.get_health() > 0:
		stats_header_label.text = tr(win_text)
	else:
		stats_header_label.text = tr(loose_text)
	stats_unit_destroyed.text = tr(units_destroyed_text) + ' : ' + str(stats[DataManager.LevelStats.UNITS_DESTROYED])
	stats_unit_lost.text = tr(units_lost_text) + ' : ' + str(stats[DataManager.LevelStats.UNITS_LOST])
	stats_phdamage.text = tr(phdamage_text) + ' : ' + str(stats[DataManager.LevelStats.PHYS_DAMAGE_COUNT])
	stats_mdamage.text = tr(mdamage_text) + ' : ' + str(stats[DataManager.LevelStats.MAGE_DAMAGE_COUNT])
	stats_pdamage.text = tr(pdamage_text) + ' : ' + str(stats[DataManager.LevelStats.PURE_DAMAGE_COUNT])
	stats_hdamage.text = tr(hdamage_text) + ' : ' + str(stats[DataManager.LevelStats.HEROES_DAMAGE_DEALT])
	stats_castlehplost.text = tr(castle_strengthl_text) + ' : ' + str(stats[DataManager.LevelStats.FORTRESS_HEALTH_LOST])
	stats_castlehprest.text = tr(castle_strengthr_text) + ' : ' + str(stats[DataManager.LevelStats.FORTRESS_HEALTH_RESTORED])
	stats_goldlost.text = tr(gold_spent_text) + ' : ' + str(stats[DataManager.LevelStats.GOLD_LOST])
	stats_tokenlost.text = tr(token_spent_text) + ' : ' + str(stats[DataManager.LevelStats.TOKEN_LOST])
	stats_foodlost.text = tr(food_spent_text) + ' : ' + str(stats[DataManager.LevelStats.FOOD_LOST])
	stats_crystalllost.text = tr(crystall_spent_text) + ' : ' + str(stats[DataManager.LevelStats.CRYSTALLS_LOST])
	stats_soulsearned.text = tr(soulsearned_text) + ' : ' + str(Player.current_souls)


func _on_button_complete_pressed() -> void:
	GameManager.win()
