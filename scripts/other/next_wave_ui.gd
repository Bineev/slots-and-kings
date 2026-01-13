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
	label_wave_remaining.text = 'Осталось пережить %s волн' % waves_remaining


func update_label():
	if next_wave_timer.time_left <= 1:
		lavel_wave_timer.text = '!!!'
		is_should_update_label = false
		next_wave_anim_player.play('hide')
		return
	lavel_wave_timer.text = str(int(next_wave_timer.time_left))
	


func set_timer(new_timer : Timer):
	next_wave_timer = new_timer
