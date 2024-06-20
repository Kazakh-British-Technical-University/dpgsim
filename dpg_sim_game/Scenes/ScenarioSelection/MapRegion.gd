extends Button

export var regionIndex = 0
var blinking = true

func _ready():
	modulate.a = 0

var t = 0
func _process(delta):
	if not blinking or not global.regionsActive[regionIndex]:
		return
	t += delta
	if t > 2:
		t -= 2
	modulate.a = (sin(PI * t) + 0.5) * 0.3

func _on_MapRegion_pressed():
	blinking = true
	if not global.regionsActive[regionIndex]:
		return
	modulate.a = 0
	global.game.soundManager.PlaySFX("Boop")
	get_parent().get_parent().get_parent().OpenScenarioList(regionIndex)


func _on_Button_mouse_entered():
	blinking = false
	if global.regionsActive[regionIndex]:
		modulate = Color.white
		modulate.a = 0.65
	else:
		modulate = Color.red
		modulate.a = 0.4

func _on_Button_mouse_exited():
	blinking = true
	modulate.a = 0
