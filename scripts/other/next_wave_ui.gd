extends PanelContainer

class_name NextWaveUI


var next_wave_timer : Timer
var is_should_update_label : bool

@onready var lavel_wave_timer: Label = %lavel_wave_timer
@onready var next_wave_anim_player: AnimationPlayer = %next_wave_anim_player
@onready var label_wave_remaining: Label = %label_wave_remaining


func _process(delta: float) -> void:
	if is_should_update_label:
		update_label()


func set_remaining_waves(waves_remaining : int):
	var current_locale : String = TranslationServer.get_locale()
	var rem_prefix : String
	match current_locale:
		'en_US':
			rem_prefix = 'There are %s waves left to survive'
		'ru_RU':
			rem_prefix = 'Осталось пережить %s волн'
	label_wave_remaining.text = rem_prefix % waves_remaining


func update_label():
	if next_wave_timer.time_left <= 1:
		lavel_wave_timer.text = '!!!'
		is_should_update_label = false
		next_wave_anim_player.play('hide')
		return
	lavel_wave_timer.text = str(int(next_wave_timer.time_left))
	


func set_timer(new_timer : Timer):
	next_wave_timer = new_timer
