extends ChooseItem

class_name ChooseItemUnit


#@onready var label_item_stats: Label = %label_item_stats


func initialize():
	label_item_name.text = slot_res.slot_name
	label_item_desc.text = slot_res.slot_description
	choose_button.text = 'ВЫБРАТЬ'
	item_texture.texture = slot_res.slot_sprite
	slot_type = slot_res.slot_type
	label_item_stats.text = generate_stats()


func generate_stats():
	var unit_stats : String
	for stat in DataManager.default_stats.keys():
		if stat == 'crit_attack' or stat.contains('scout'):
			continue
		if DataManager.default_stats[stat] != slot_res.get(stat):
			unit_stats += ('%s: %d\n') % [DataManager.default_stats_to_rus[stat], slot_res.get(stat)]
	
	return unit_stats
