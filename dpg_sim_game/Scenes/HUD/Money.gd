extends Control

var total = 0
var burn : float = 0
var costPos : Vector2 
func Start():
	costPos = $Cost.rect_position
	$Total.text = trans.local("DPGS") + ": "
	$Burn.text = trans.local("RATE") + ": "
	burn = global.mainConfig["Salary"]
	$TotalMoney.add_color_override("font_color", Color.black)
	_UpdateText()

func SetMoney(_total):
	total = int(_total)
	_UpdateText()

func AddBurn(_burn):
	burn += _burn
	_UpdateText()

func Spend(_cost):
	global.game.soundManager.PlaySFX("Ching")
	var cost = int(_cost)
	total -= cost
	_UpdateText()
	$Cost.text = str(-cost)
	$Cost.visible = true
	var tween = create_tween()
	tween.tween_property($Cost, "rect_position", costPos + Vector2.DOWN * 30, 0.4)
	tween.tween_callback(self, "_SpendComplete")
	
	if total <= 0:
		$TotalMoney.add_color_override("font_color", Color.red)
		global.game.GameOver()

func Salary():
	Spend(actualBurn())

func actualBurn():
	return burn * global.BurnMultiplier()

func _UpdateText():
	$TotalMoney.text = str(total)
	$BurnMoney.text = str(actualBurn())

func _SpendComplete():
	yield(get_tree().create_timer(0.5),"timeout")
	$Cost.visible = false
	$Cost.rect_position = costPos
