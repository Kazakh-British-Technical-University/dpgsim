extends ColorRect

func Start():
	$DateCounter.Start()
	$Money.Start()

func StartProject():
	$Money.Spend(global.curProject["MoneyCost"])

var totalDays = 0
func CheckTime():
	totalDays += 1
	if $DateCounter.day == 1:
		$Money.Salary()
