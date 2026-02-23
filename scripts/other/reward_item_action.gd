extends RewardItem

class_name RewardItemAction


@onready var label_reward_info: Label = %label_reward_info


func initialize():
	var current_locale : String = TranslationServer.get_locale()
	var current_reward_action_table : Dictionary
	match current_locale:
		'en_US':
			current_reward_action_table = DataManager.reward_action_table_en
		'ru_RU':
			current_reward_action_table = DataManager.reward_action_table_ru
	label_reward_info.text = current_reward_action_table[reward_type]
	show()
