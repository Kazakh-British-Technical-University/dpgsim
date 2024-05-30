extends Control

func Start():
	$CreditsList.text = trans.local("CREDITS_LIST")
	$MM_Button.Start()

func _on_MM_Button_buttonPressed():
	visible = false
	$"..".ShowMainMenu(true)
