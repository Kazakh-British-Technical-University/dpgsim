extends Node2D

var normalColor : Color
var selectedColor = Color.red

var selected = false

func _ready():
	normalColor = $InnerFrame.color

func _on_Button_pressed():
	Select(not selected)

func Select(on):
	selected = on
	if on:
		$Frame.color = selectedColor
	else:
		$Frame.color = normalColor
