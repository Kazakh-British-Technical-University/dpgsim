extends Node2D

func Start():
	$Exit_Button.connect("buttonPressed", global.game, "ExitGame")
	$Continue_Button.Start()
	$Settings_Button.Start()
	$Exit_Button.Start()

func ShowMainMenu(show):
	$Continue_Button.visible = show
	$Settings_Button.visible = show
	$Exit_Button.visible = show

func _on_Settings_Button_buttonPressed():
	$Settings.Start()
	$Settings.visible = true
	ShowMainMenu(false)

func _on_Continue_Button_buttonPressed():
	global.game.PauseGame(false)
