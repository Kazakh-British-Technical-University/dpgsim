extends ColorRect

var curEvent

func CheckEvents(day):
	for event in global.events:
		if len(event["Day"]) == 0:
			continue
		if int(event["Phase"]) == global.curPhaseIndex + 1 and global.curScenario()["ScenarioEvents"].has(float(event["ID"])):
			if event["FromStart"] == "TRUE":
				if int(event["Day"]) == day:
					ShowEvent(event)
			else:
				if day == int(global.curProject["TimeCost"]) - int(event["Day"]):
					ShowEvent(event)

func ShowEvent(event):
	global.game.PauseTimer(true)
	curEvent = event
	visible = true
	$Title.text = curEvent["Title"]
	$Body.text = curEvent["Description"]
	SetupOption($A_Button, "First")
	
	if len(curEvent["Second option"]) > 0:
		SetupOption($B_Button, "Second")
		$B_Button.visible = true
	else:
		$B_Button.visible = false

func SetupOption(button, number):
	button.Start()
	button.SetText(curEvent[number + " option"])
	if curEvent[number + " option outcome status"] == "Good":
		button.modulate = Color.green
	else:
		button.modulate = Color.red

var selectedOption = ""
func _on_A_Button_buttonPressed():
	SetupTooltip("First")

func _on_B_Button_buttonPressed():
	SetupTooltip("Second")

func SetupTooltip(option):
	selectedOption = option
	global.game.gameTooltip.SetTooltip(
		curEvent[selectedOption + " option"],
		curEvent[selectedOption + " option tooltip"],
		funcref(self, "ApplyOutcome")
	)

func ApplyOutcome():
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
	

