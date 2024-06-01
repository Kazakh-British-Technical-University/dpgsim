class_name MainGame
extends Node2D

onready var gameTooltip = $Tooltip
onready var dateCounter = $Header/DateCounter
onready var teamScreen = $TeamScreen

func _ready():
	global.game = self
	$WebInterface.ConnectToWeb()
	yield(get_tree().create_timer(0.1),"timeout")
	LoadFiles()
	yield(get_tree().create_timer(1),"timeout")
	$MainMenu.visible = true
	$MainMenu.Start()
	$MM_Button.Start()
	dateCounter.connect("dayTick", $MainSession, "GenPoints")
	dateCounter.connect("dayTick", $Header, "CheckTime")

func LoadFiles():
	$WebInterface.LoadTranslations()
	$WebInterface.LoadMainConfig()
	$WebInterface.LoadScenarios()
	$WebInterface.LoadProjects()

func StartScenario():
	$MapScreen.visible = false
	global.curPhaseIndex = 0
	$Header.Start()
	$TeamScreen.Start()
	$MainSession.ResetCounters()
	$Header/Money.SetMoney(global.curScenario()["Money"])
	$Header.visible = true
	StartNextPhase()

func StartNextPhase():
	$Header/PhaseHUD.StartPhase()
	$Projects.Start()
	$Projects.visible = true

func StartProject():
	$Projects.visible = false
	$TeamScreen.UpdateAvailableWorkers()
	if global.curPhaseIndex < 2:
		StartSession()
	else:
		$TeamQuestion.Start()
		$TeamQuestion.visible = true

func StartSession():
	PauseTimer(false)
	$Header.StartProject()
	$MainSession.Start()
	$MainSession.visible = true

func ProjectComplete():
	PauseTimer(true)
	global.ApplyInsights()
	$MainSession.visible = false
	if global.curPhaseIndex == 1:
		##################################################
		# print("name your product")
		pass
	if global.curPhaseIndex < 8:
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		Win()

func PauseTimer(pause):
	if pause:
		dateCounter.timerOn = false
	else:
		dateCounter.t = 0
		dateCounter.timerOn = true

func HireWorker(quantity):
	$Header/Money.AddBurn(int(global.mainConfig["Salary"]) * quantity)

func _on_Start_Button_buttonPressed():
	$MainMenu.visible = false
	$MM_Button.visible = true
	$MapScreen.visible = true
	$MapScreen.Start()

func _on_MM_Button_buttonPressed():
	PauseTimer(true)
	global.ResetGame()
	$Header/PhaseHUD.ResetPhases()
	for child in get_children():
		child.visible = false
	$MainMenu.visible = true

func OpenTeamScreen():
	$TeamScreen.visible = true

func CloseTeamScreen():
	$TeamScreen.visible = false
	StartSession()


func GameOver():
	PauseTimer(true)
	$MainSession/Office.ClearQueue()
	$Header/PhaseHUD.ShowButton(false)
	var callback = funcref(self, "_on_MM_Button_buttonPressed")
	gameTooltip.SetTooltip(trans.local("GAME_OVER"), trans.local("GAME_OVER_DESCR"), callback)

func Win():
	$WinScreen.Start()
	$WinScreen.visible = true
	$WinScreen/Scores.text = trans.local("SCORES") + ": " + str(CalcScores())

func CalcScores():
	var points = 0
	points += 20 * $MainSession/FitCounter.good
	points -= 25 * $MainSession/FitCounter.bad
	points += 15 * $MainSession/DevCounter.good
	points -= 20 * $MainSession/DevCounter.bad
	points += 10 * $MainSession/MarketCounter.good
	points -= 15 * $MainSession/MarketCounter.bad
	if $Header.totalDays < 336:
		points += (336 - $Header.totalDays) * 5
		points += 336 * 3
	else:
		if $Header.totalDays < 672:
			points += (672 - $Header.totalDays) * 3
	points += $Header/Money.total * 5
	return points
