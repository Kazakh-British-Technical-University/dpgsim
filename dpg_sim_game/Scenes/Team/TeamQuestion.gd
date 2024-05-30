extends Node2D

func Start():
	$Title.text = trans.local("TEAM_ACTIONS")
	$Body.text = trans.local("TEAM_ACTIONS_DESCR")
	$Open_Button.Start()
	$Skip_Button.Start()

func _on_Open_Button_buttonPressed():
	visible = false
	global.game.OpenTeamScreen()

func _on_Skip_Button_buttonPressed():
	visible = false
	global.game.StartSession()
