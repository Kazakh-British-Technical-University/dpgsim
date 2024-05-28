class_name GameTooltip
extends Node2D

var callback

func SetTooltip(title, body, _callback):
	$Title.text = title
	$Body.text = body
	$MM_Button.Start()
	callback = _callback
	visible = true

func _on_MM_Button_buttonPressed():
	visible = false
	callback.call_func()
	callback = null

func _on_CloseButton_pressed():
	visible = false
	callback = null
