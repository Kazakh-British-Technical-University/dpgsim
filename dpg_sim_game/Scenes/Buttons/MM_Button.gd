extends Button

signal buttonPressed

export var buttonText = "Start"
export var sPressed = preload("res://Sprites/UI/MainMenuLongPresses.png")
export var sReleased = preload("res://Sprites/UI/MainMenuLong.png")
export var usedFont = preload("res://Fonts/Font_Regular32.tres")
export var pressedOffset = 6

func Start():
	if len(buttonText) > 0:
		$Label.text = trans.local(buttonText)
		$Label.add_font_override("font", usedFont)
	icon = sReleased

func SetText(_text):
	buttonText = _text
	$Label.text = buttonText

func _on_MM_Button_button_down():
	global.game.soundManager.PlaySFX("KeyDown")
	icon = sPressed
	$Label.rect_position += Vector2.DOWN * pressedOffset

func _on_MM_Button_button_up():
	global.game.soundManager.PlaySFX("KeyUp")
	icon = sReleased
	$Label.rect_position -= Vector2.DOWN * pressedOffset
	if stopShakingOnPress:
		shaking = false
	yield(get_tree().create_timer(0.05),"timeout")
	emit_signal("buttonPressed")

var shaking = false
var stopShakingOnPress = false
func StartShaking():
	rect_pivot_offset = rect_size / 2
	shaking = true

var t = 0
func _process(delta):
	if not shaking:
		t = 0
		rect_rotation = 0
		return
	t += delta
	if t < 0.25:
		rect_rotation = 2 * sin(4 * PI * t / 0.25)
	else:
		rect_rotation = 0
	if t > 1:
		t = 0
