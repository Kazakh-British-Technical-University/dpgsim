extends ColorRect

func Start():
	$DateCounter.Start()
	$Money.Start()

func StartProject():
	curDays = 0
	$Money.Spend(global.curProject["MoneyCost"])

var curDays = 0
var totalDays = 0
func CheckTime():
	curDays += 1
	totalDays += 1
	$"../MainSession".SetProgress(curDays)
	if curDays == int(global.curProject["TimeCost"]):
		$PhaseHUD.OverTime()
	if $DateCounter.day == 1:
		$Money.Salary()
