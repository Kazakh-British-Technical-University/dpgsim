extends Control

func Start():
	$ActionOption1.present = global.mainConfig["Phases"][global.curPhaseIndex]["Fit"]
	$ActionOption2.present = global.mainConfig["Phases"][global.curPhaseIndex]["Dev"]
	$ActionOption3.present = global.mainConfig["Phases"][global.curPhaseIndex]["Market"]
	
	$ActionOption1.Start()
	$ActionOption2.Start()
	$ActionOption3.Start()
	$Back_Button.Start()

func StartAction(index):
	global.actionsActive[index] = true
	global.game.OpenActionScreen(false)

func _on_Back_Button_buttonPressed():
	global.game.OpenActionScreen(false)
