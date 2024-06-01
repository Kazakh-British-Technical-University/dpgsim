extends Control

func Start():
	$Title.text = trans.local("YOU_WIN")
	$MM_Button.Start()

func _on_MM_Button_buttonPressed():
	global.game._on_MM_Button_buttonPressed()
