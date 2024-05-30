extends Control

func Start():
	$Title.text = trans.local("YOU_WIN")
	$Title/MM_Button.Start()
	# Count points

func _on_MM_Button_buttonPressed():
	global.game._on_MM_Button_buttonPressed()
