extends Node

# Dependencies
onready var total_node = 		$"../PanelContainer/MarginContainer/HudLeft/Money/Margin/Control/Label"
onready var total_money_node = 	$"../PanelContainer/MarginContainer/HudLeft/Money/Margin/Control/Value"
onready var cost_node = 		$"../PanelContainer/MarginContainer/HudLeft/Money/Margin/Control/Cost"
onready var burn_node = 		$"../PanelContainer/MarginContainer/HudLeft/BurnRate/Margin/Control/Label"
onready var burn_money = 		$"../PanelContainer/MarginContainer/HudLeft/BurnRate/Margin/Control/Value"

var total = 0
var burn : int = 0
var maxBurn = 0
var costPos : Vector2 
var purple = Color(131.0/255,82.0/255,120.0/255)
func Start():
	costPos = cost_node.rect_position
	total_node.text = trans.local("DPGS") + ": "
	burn_node.text = trans.local("RATE") + ": "
	burn = global.mainConfig["Salary"]
	maxBurn = 0
	total_money_node.add_color_override("font_color", purple)
	_UpdateText()

func SetMoney(_total):
	total = int(_total)
	_UpdateText()

func AddMoney(amount):
	if amount > 0:
		total += amount
		_UpdateText()
	else:
		Spend(-amount)

func AddBurn(_burn):
	burn += _burn
	_UpdateText()

func SetMaxBurn():
	if (maxBurn < burn):
		maxBurn = burn

func Spend(_cost):
	global.game.soundManager.PlaySFX("Ching")
	var cost = int(_cost)
	total -= cost
	_UpdateText()
	cost_node.text = str(-cost)
	cost_node.visible = true
	var tween = create_tween()
	tween.tween_property(cost_node, "rect_position", costPos + Vector2.DOWN * 30, 0.4)
	tween.tween_callback(self, "_SpendComplete")
	
	if total <= 0:
		total_money_node.add_color_override("font_color", Color.red)
		global.game.GameOver()

func Salary():
	Spend(max(burn, maxBurn) * global.BurnMultiplier())
	maxBurn = burn

func _UpdateText():
	total_money_node.text = str(total)
	burn_money.text = str(burn * global.BurnMultiplier())

func _SpendComplete():
	yield(get_tree().create_timer(0.5),"timeout")
	cost_node.visible = false
	cost_node.rect_position = costPos
