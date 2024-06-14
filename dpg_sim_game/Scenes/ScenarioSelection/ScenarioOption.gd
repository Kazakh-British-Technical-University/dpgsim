extends Button

var normalColor : Color
export var selectedColor = Color.red

var selected = false
var scenarioIndex = 0

func _ready():
	normalColor = $ScenarioFrame.modulate

func Select(on):
	global.game.soundManager.PlaySFX("Tick")
	selected = on
	if on:
		$ScenarioFrame.modulate = selectedColor
	else:
		$ScenarioFrame.modulate = normalColor

func _on_ScenarioOption_pressed():
	get_parent().get_parent().get_parent().get_parent().SelectScenario(scenarioIndex)
	Select(true)

func InitScenarioButton(index):
	scenarioIndex = index
	var scenario = global.scenarios[index]
	$Title.text = trans.local(scenario["Title"])
	$Description.text = trans.local(scenario["Description"])
	var icon = load("res://Scenes/ScenarioSelection/SDG icons/SDG_Icon" + str(scenario["SDG"]) + ".tscn")
	$sdgIcon.add_child(icon.instance())
