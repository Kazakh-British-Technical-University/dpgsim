class_name PointCounter
extends Control

# Dependencies
onready var label = $Control/Label
onready var goodLabel = $Control/PointsMeter/GoodPoints
onready var badLabel = $Control/PointsMeter/BadPoints

var present = true

var good = 0
var bad = 0

func Start():
	visible = present
	UpdateText()

func GetPointPosition(isGood) -> Vector2:
	var target = goodLabel if isGood else badLabel
	return target.get_global_transform().xform(target.rect_size / 2)

func LocalizeText(labelKey: String):
	label.text = trans.local(labelKey)

func AddPoint(isGood):
	if isGood:
		good += 1
	else:
		bad += 1
	UpdateText()

func CleanPoint():
	if bad > 0:
		bad -= 1
		UpdateText()

func UpdateText():
	goodLabel.text = str(good)
	badLabel.text = str(bad)

func Reset():
	good = 0
	bad = 0
	UpdateText()
