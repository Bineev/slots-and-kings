extends VBoxContainer

class_name ChooseItemHero


var hero : Hero


func initialize():
	await get_tree().process_frame
	add_child(hero, true)
	hero.initialize()


func set_hero(new_hero : Hero):
	hero = new_hero


func _on_choose_button_pressed() -> void:
	SignalManager.on_hero_choose_done.emit(hero)
