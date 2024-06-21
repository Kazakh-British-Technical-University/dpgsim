class_name GameTooltip
extends Node2D

var callback
var closeIsProceed = false

func SetTooltip(title, body, _callback):
	$Title.text = title
	$Body.text = body
	$MM_Button.Start()
	callback = _callback
	visible = true

func _on_MM_Button_buttonPressed():
	visible = false
	if callback != null:
		callback.call_func()

func _on_CloseButton_pressed():
	global.game.soundManager.PlaySFX("Tick")
	if closeIsProceed:
		closeIsProceed = false
		_on_MM_Button_buttonPressed()
		return
	visible = false
