extends Node2D

func Start():
	$Start_Button.connect("buttonPressed", global.game, "_on_Start_Button_buttonPressed")
	$Start_Button.Start()
	$Settings_Button.Start()
	$Credits_Button.Start()
