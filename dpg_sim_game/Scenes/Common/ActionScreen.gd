extends Control

func Start():
	$ActionOption1.present = int(global.actions[0]["StartingPhase"]) <= global.curPhaseIndex
	$ActionOption2.present = int(global.actions[1]["StartingPhase"]) <= global.curPhaseIndex
	$ActionOption3.present = int(global.actions[2]["StartingPhase"]) <= global.curPhaseIndex
	$ActionOption4.present = int(global.actions[3]["StartingPhase"]) <= global.curPhaseIndex
	
	$ActionOption1.Start()
	$ActionOption2.Start()
	$ActionOption3.Start()
	$ActionOption4.Start()
	$Back_Button.Start()

func StartAction(index):
	if index == 3:
		global.actionsActive[0] = true
		global.actionsActive[1] = true
		global.actionsActive[2] = true
	else:
		global.actionsActive[index] = true
	global.game.OpenActionScreen(false)

func _on_Back_Button_buttonPressed():
	global.game.OpenActionScreen(false)
