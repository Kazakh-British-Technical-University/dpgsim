extends Button

export var regionIndex = 0

func _ready():
	modulate.a = 0

func _on_MapRegion_pressed():
	modulate.a = 0
	global.game.soundManager.PlaySFX("Boop")
	get_parent().get_parent().get_parent().OpenScenarioList(regionIndex)


func _on_Button_mouse_entered():
	modulate.a = 0.65

func _on_Button_mouse_exited():
	modulate.a = 0
