extends ColorRect

var curProjectDays = 0
var curEvent

func _ready():
	visible = false

func StartProject():
	curProjectDays = 0

func CheckTime():
	curProjectDays += 1
	CheckEvents()

func CheckEvents():
	for event in global.events:
		if len(event["Day"]) == 0:
			continue
		if int(event["Phase"]) == global.curPhaseIndex:
			if event["FromStart"] == "TRUE":
				if int(event["Day"]) == curProjectDays:
					ShowEvent(event)
			else:
				if curProjectDays == int(global.curProject["TimeCost"]) - int(event["Day"]):
					ShowEvent(event)

func ShowEvent(event):
	global.game.PauseTimer(true)
	curEvent = event
	visible = true
	$Title.text = curEvent["Name"]
	$Body.text = curEvent["Description"]
	$A_Button.Start()
	$A_Button.SetText(curEvent["First option"])
	if len(curEvent["Second option"]) > 0:
		$B_Button.Start()
		$B_Button.visible = true
		$B_Button.SetText(curEvent["Second option"])
	else:
		$B_Button.visible = false

func _on_A_Button_buttonPressed():
	CloseWindow()

func _on_B_Button_buttonPressed():
	CloseWindow()

func CloseWindow():
	global.game.PauseTimer(false)
	visible = false
