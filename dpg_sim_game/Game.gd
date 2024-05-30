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
		print("name your product")
	if global.curPhaseIndex < 8:
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		print("You win")

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
