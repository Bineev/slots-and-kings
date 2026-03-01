extends VBoxContainer

class_name ChooseItemHero


var hero : Hero


func initialize():
	await get_tree().process_frame
	add_child(hero, true)
	move_child(hero, 0)
	hero.initialize()


func set_hero(new_hero : Hero):
	hero = new_hero


func _on_choose_button_pressed() -> void:
	SoundManager.play_ui(self, DataManager.sound_dict[DataManager.SoundType.HERO])
	hero.remove_hero_slot()
	SignalManager.on_hero_choose_done.emit(hero)
	SignalManager.on_choose_reward_item.emit()
	SignalManager.on_choose_item.emit(Player.create_slot_scene(hero.hero_slot_res), DataManager.SlotType.ULT)
	
