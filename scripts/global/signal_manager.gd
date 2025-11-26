extends Node

signal spin_columns
signal on_create_player_unit(unit : Unit, slots : Array[Slot], owner : DataManager.UnitOwner)
signal on_spin_end
signal on_get_res(res_type : DataManager.ResType, res_amount : int)
signal on_entity_choosed(owner : Building, slot : Slot)
signal on_show_choose_UI(choose_UI : ChooseUI)
