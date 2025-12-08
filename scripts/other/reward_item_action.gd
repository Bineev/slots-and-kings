extends RewardItem

class_name RewardItemAction


@onready var label_reward_info: Label = %label_reward_info


func initialize():
	match reward_type:
		DataManager.RewardType.UNIT:
			label_reward_info.text = 'Выбор юнита'
		DataManager.RewardType.UPGRADE:
			label_reward_info.text = 'Выбор улучшения'
		DataManager.RewardType.PERC:
			label_reward_info.text = 'Выбор перка'
		DataManager.RewardType.HERO:
			label_reward_info.text = 'Выбор героя'
		DataManager.RewardType.REMOVER:
			label_reward_info.text = 'Удалить слот'
		DataManager.RewardType.BLACK_MARKET:
			label_reward_info.text = 'Черный рынок'
		DataManager.RewardType.MARKET:
			label_reward_info.text = 'Торговец'
