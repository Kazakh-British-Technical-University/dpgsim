extends Node2D

var scenarioPrefab = preload("res://Scenes/ScenarioSelection/ScenarioOption.tscn")
onready var buttonsParent = $ScenarioList/ScrollContainer/VBoxContainer
var buttonsList = []

func Start():
	$ScenarioList/Back_Button.Start()
	$ScenarioList/Start_Button.Start()
	_on_Back_Button_buttonPressed()
	for regionInd in range(7):
		for i in range(global.scenarios.size()):
			if (global.scenarios[i]["MapRegion"] == regionInd):
				global.regionsActive[regionInd] = true
				break
	global.game.gameTooltip.SetTooltip(trans.local("MAP_POPUP_TITLE"), trans.local("MAP_POPUP_DESC"), null)

func OpenScenarioList(region):
	$Map.visible = false
	$ScenarioList.visible = true
	for i in range(global.scenarios.size()):
		if (global.scenarios[i]["MapRegion"] == region):
			var newButton = scenarioPrefab.instance()
			buttonsParent.add_child(newButton)
			newButton.InitScenarioButton(i)
			buttonsList.append(newButton)

func SelectScenario(var scenarioIndex):
	global.activeScenarioIndex = scenarioIndex
	$ScenarioList/Start_Button.visible = true
	for button in buttonsList:
		button.Select(false)



func _on_Back_Button_buttonPressed():
	$Map.visible = true
	$ScenarioList.visible = false
	$ScenarioList/Start_Button.visible = false
	$ScenarioList/ScrollContainer.scroll_vertical = 0
	for i in range(buttonsParent.get_child_count()):
		buttonsParent.get_child(i).queue_free()
		buttonsList.clear()

func _on_Start_Button_buttonPressed():
	var desc = trans.local(global.curScenario()["Description"]) + "\n\n"
	desc += trans.local("BUDGET") + ": " + str(global.curScenario()["Money"])
	var callback = funcref(global.game, "StartScenario")
	global.game.gameTooltip.SetTooltip(trans.local(global.curScenario()["Title"]), desc, callback)
