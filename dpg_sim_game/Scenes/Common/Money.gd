extends ColorRect

var total = 0
var burn = 0
var costPos : Vector2 
func Start():
	costPos = $Cost.rect_position
	$Total.text = trans.local("DPGS") + ": "
	$Burn.text = trans.local("RATE") + ": "

func SetMoney(_total):
	total = int(_total)
	_UpdateText()

func AddBurn(_burn):
	burn += _burn

func Spend(_cost):
	var cost = int(_cost)
	if total >= cost:
		total -= cost
		_UpdateText()
		$Cost.text = str(-cost)
		$Cost.visible = true
		var tween = create_tween()
		tween.tween_property($Cost, "rect_position", costPos + Vector2.DOWN * 64, 1)
		tween.tween_callback(self, "_SpendComplete")
		return true
	else:
		return false

func Salary():
	Spend(burn)


func _UpdateText():
	$TotalMoney.text = str(total)
	$BurnMoney.text = str(burn)

func _SpendComplete():
	yield(get_tree().create_timer(0.5),"timeout")
	$Cost.visible = false
	$Cost.rect_position = costPos
