extends Node2D

func Start():
	$Start_Button.connect("buttonPressed", global.game, "_on_Start_Button_buttonPressed")
	$Start_Button.Start()
	$Settings_Button.Start()
	$Credits_Button.Start()
	$LanguageRadio.Start()

func _on_Credits_Button_buttonPressed():
	$Credits.visible = true
	$Credits.Start()
	ShowMainMenu(false)
	
func ShowMainMenu(show):
	$Start_Button.visible = show
	$Settings_Button.visible = show
	$Credits_Button.visible = show
	$LanguageRadio.visible = show

func _on_Settings_Button_buttonPressed():
	$Settings.Start()
	$Settings.visible = true
	ShowMainMenu(false)

