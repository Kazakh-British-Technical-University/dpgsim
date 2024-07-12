class_name MainGame
extends Node2D

onready var gameTooltip = $Tooltip
onready var dateCounter = $Header/DateCounter
onready var teamScreen = $TeamScreen
onready var soundManager = $Sounds

func _ready():
	global.game = self
	$WebInterface.ConnectToWeb()
	yield(get_tree().create_timer(0.1),"timeout")
	$WebInterface.LoadFiles()
	yield(get_tree().create_timer(1.5),"timeout")
	$MainMenu.visible = true
	$MainMenu.Start()
	$PauseMenu.Start()
	$MM_Button.Start()
	dateCounter.connect("dayTick", $MainSession, "CheckTime")
	dateCounter.connect("dayTick", $Header, "CheckTime")

func StartScenario():
	$MapScreen.visible = false
	global.curPhaseIndex = 0
	$Header.Start()
	$Header/Money.SetMoney(global.curScenario()["Money"])
	$Header/PhaseHUD.StartPhase()
	$Header.visible = true
	$TeamScreen.Start()
	$MainSession.Start()
	$MainSession.ResetCounters()
	$MainSession.FirstStart()
	$MainSession.visible = true
	global.curPhaseIndex = -1
	gameTooltip.SetTooltip(trans.local("SCENARIO_POPUP_TITLE"), trans.local("SCENARIO_POPUP_DESC"), null)

func StartNextPhase():
	$Header/PhaseHUD.StartPhase()
	$Projects.Start()
	yield(get_tree().create_timer(0.1),"timeout")
	$Projects.visible = true

func StartProject():
	$Projects.visible = false
	$TeamScreen.UpdateAvailableWorkers()
	PauseTimer(false)
	$Header.StartProject()
	$ActionScreen.Start()
	$MainSession.StartProject()
	$MainSession.visible = true

func ProjectComplete():
	$MainSession.visible = false
	if global.curPhaseIndex == -1:
		AdvancePhase()
		return
	PauseTimer(true)
	global.ApplyInsights()
	$Header/PhaseHUD.ShowButton(false)
	if global.curPhaseIndex == 1:
		##################################################
		# print("name your product")
		pass
	AdvancePhase()

func AdvancePhase():
	if global.curPhaseIndex < 8:
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		Win()

var timerPaused = true
func PauseTimer(pause):
	timerPaused = pause
	if pause:
		dateCounter.timerOn = false
	else:
		dateCounter.t = 0
		dateCounter.timerOn = true

func GameOver():
	PauseTimer(true)
	$MainSession/Office.ClearQueue()
	$Header/PhaseHUD.ShowButton(false)
	gameTooltip.closeIsProceed = true
	var callback = funcref(self, "ExitGame")
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



func _on_Start_Button_buttonPressed():
	$MainMenu.visible = false
	$MM_Button.visible = true
	$MapScreen.visible = true
	$MapScreen.Start()

func _on_language_changed(lang):
	$WebInterface.ChangeLanguage(lang)
	yield(get_tree().create_timer(0.5),"timeout")
	var _reload = get_tree().reload_current_scene()

func PauseGame(pause):
	if not timerPaused:
		if pause:
			dateCounter.timerOn = false
		else:
			dateCounter.t = 0
			dateCounter.timerOn = true
	$PauseMenu.visible = pause

func ExitGame():
	PauseTimer(true)
	global.ResetGame()
	$Header/PhaseHUD.ResetPhases()
	for child in get_children():
		if !(child is CanvasItem):
			continue
		child.visible = false
	$PauseMenu.visible = false
	$MainMenu.visible = true

func HireWorker(quantity):
	$Header/Money.AddBurn(int(global.mainConfig["Salary"]) * quantity)
	$MainSession/Office.UpdateMinis()

func OpenTeamScreen(open):
	PauseTimer(open)
	$TeamScreen.visible = open
	$MainSession.visible = not open
	if not open:
		$Header/Money.SetMaxBurn()

func OpenActionScreen(open):
	PauseTimer(open)
	$ActionScreen.visible = open
	$MainSession.visible = not open
	
func Overtime():
	$Header/PhaseHUD.OverTime()

func CheckEvents(day):
	$EventManager.CheckEvents(day)

func AddMoney(amount):
	$Header/Money.AddMoney(amount)
