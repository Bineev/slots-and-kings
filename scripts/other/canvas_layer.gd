extends CanvasLayer

class_name ShadersLayer


var strength = 0.1
var curStrength = 0
var is_should_shake : bool


func _ready() -> void:
	SignalManager.on_player_get_hit.connect(shake)
	visible = false


func _process(delta):
	curStrength = max(curStrength - delta, 0)
	if is_should_shake or Input.is_action_just_pressed("SpaceBar"):
		curStrength = strength;
		$rect_shake_shader.material.set_shader_parameter('ShakeStrength', max(curStrength,0))
	if Input.is_action_just_released("SpaceBar"):
		$rect_shake_shader.material.set_shader_parameter('ShakeStrength', 0)

func shake():
	is_should_shake = true
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_callback(disable_shake).set_delay(0.05)


func disable_shake():
	is_should_shake = false
	visible = false
	$rect_shake_shader.material.set_shader_parameter('ShakeStrength', 0)
