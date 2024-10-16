extends ColorRect

var curEvent

func CheckEvents(day):
	for eventID in global.events:
		var event = global.events[eventID]
		if len(event["Day"]) == 0:
			continue
		if int(event["Phase"]) == global.curPhaseIndex + 1 and global.curScenario()["ScenarioEvents"].has(event["ID"]):
			if event["FromStart"] == "TRUE":
				if int(event["Day"]) == day:
					_ShowEvent(event)
			else:
				if day == int(global.curProject["TimeCost"]) - int(event["Day"]):
					_ShowEvent(event)

func _ShowEvent(event):
	global.game.soundManager.PlaySFX("Ding")
	global.game.PauseTimer(true)
	curEvent = event
	visible = true
	$Title.text = curEvent["Title"]
	$Body.text = curEvent["Description"]
	_SetupOption($A_Button, "First")
	
	if len(curEvent["Second option"]) > 0:
		_SetupOption($B_Button, "Second")
		$B_Button.visible = true
	else:
		$B_Button.visible = false

func _SetupOption(button, number):
	button.Start()
	button.SetText(curEvent[number + " option"])
	if curEvent[number + " option outcome status"] == "Good":
		button.modulate = Color.green
	else:
		button.modulate = Color.red

var selectedOption = ""
func _on_A_Button_buttonPressed():
	_SetupTooltip("First")

func _on_B_Button_buttonPressed():
	_SetupTooltip("Second")

func _SetupTooltip(option):
	selectedOption = option
	global.game.gameTooltip.SetTooltip(
		curEvent[selectedOption + " option"],
		curEvent[selectedOption + " option tooltip"],
		funcref(self, "_ApplyOutcome")
	)

func _ApplyOutcome():
	global.game.PauseTimer(false)
	visible = false
	var param = curEvent[selectedOption + " option outcome value (param)"]
	var value = int(curEvent[selectedOption + " option outcome value (value)"])
	if param.count("money") > 0:
		global.game.AddMoney(value)
	if param.count("product insights") > 0:
		if value > 0:
			global.productP += value
		else:
			global.productN -= value
	if param.count("dev insights") > 0:
		if value > 0:
			global.techP += value
		else:
			global.techN -= value
	if param.count("market insights") > 0:
		if value > 0:
			global.marketP += value
		else:
			global.marketN -= value
	if param.count("team insights") > 0:
		global.teamInsight += value
	

