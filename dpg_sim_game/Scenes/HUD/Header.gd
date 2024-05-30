extends ColorRect

func Start():
	$DateCounter.Start()
	$Money.Start()
	#$PhaseHUD.StartPhase()

func StartProject():
	curDays = 0
	$Money.Spend(global.curProject["MoneyCost"])

var curDays = 0
func CheckTime():
	curDays += 1
	if curDays == int(global.curProject["TimeCost"]):
		curDays = 0
		$PhaseHUD.OverTime()
	if $DateCounter.day == 1:
		$Money.Salary()
