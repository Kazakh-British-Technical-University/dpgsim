extends Control

var timerOn = false
var dayDuration = 1
var day = 0
var month = 0
var year = 0

signal dayTick

func Start():
	dayDuration = global.mainConfig["DayLength"]
	var time = OS.get_datetime()
	day = time["day"]
	month = time["month"]
	year = time["year"]
	if day > 28:
		day = 28
	UpdateText()

var t = 0.0
func _process(delta):
	if not timerOn:
		return
	
	t += delta
	if t >= dayDuration:
		t -= dayDuration
		day += 1
		UpdateDate()
		UpdateText()
		emit_signal("dayTick")

func UpdateDate():
	if day > 28:
		day -= 28
		month += 1
		if month > 12:
			month -= 12
			year += 1

func UpdateText():
	#$Date.text = trans.local("DATE") + ":\n"
	$Date.text = ""
	if day < 10:
		$Date.text += "0"
	$Date.text += str(day) + "."
	if month < 10:
		$Date.text += "0"
	$Date.text += str(month) + "." + str(year)
