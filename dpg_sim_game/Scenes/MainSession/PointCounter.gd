class_name PointCounter
extends Label

var present = true

var good = 0
var bad = 0
var goodPos : Vector2
var badPos : Vector2

func Start():
	visible = present
	UpdateText()
	goodPos = $GoodPoints.rect_global_position + $GoodPoints.rect_size / 2
	badPos = $BadPoints.rect_global_position + $BadPoints.rect_size / 2

func AddPoint(isGood):
	if isGood:
		good += 1
	else:
		bad += 1
	UpdateText()

func UpdateText():
	$GoodPoints.text = str(good)
	$BadPoints.text = str(bad)

func Reset():
	good = 0
	bad = 0
	UpdateText()
