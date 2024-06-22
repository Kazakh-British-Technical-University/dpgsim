extends Node2D

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

onready var counters = [$FitCounter, $DevCounter, $MarketCounter]
var PGR = 0.0
var NPR = 0.0
var PGR_limit = 0.0
var NPR_limit = 0.0
func Start():
	$Office.Start()
	$Team_Button.Start()
	$Actions_Button.Start()
	$Project_Button.Start()
	$Project_Button.StartShaking()
	
	$FitCounter.text = trans.local("FIT_PTS")
	$DevCounter.text = trans.local("DEV_PTS")
	$MarketCounter.text = trans.local("MARKET_PTS")
	
	PGR = float(global.mainConfig["PGR"])
	NPR = float(global.mainConfig["NPR"])
	PGR_limit = float(global.mainConfig["PGR_limit"])
	NPR_limit = float(global.mainConfig["NPR_limit"])

func FirstStart():
	$Team_Button.visible = false
	$ProjectProgress.visible = false
	$Actions_Button.visible = false
	$Project_Button.visible = true
	$Office.ResetOffice()

func StartProject():
	$Team_Button.visible = global.curPhaseIndex > 1
	if global.curPhaseIndex == 2:
		global.game.PauseTimer(true)
		global.game.gameTooltip.closeIsProceed = true
		global.game.gameTooltip.SetTooltip(
			trans.local("TEAM_POPUP_TITLE"),
			trans.local("TEAM_POPUP_DESC"),
			funcref(self, "Unpause"))
		$Team_Button.StartShaking()
		$Team_Button.stopShakingOnPress = true
	
	$Actions_Button.visible = global.curPhaseIndex > 2
	if global.curPhaseIndex == 3:
		global.game.PauseTimer(true)
		global.game.gameTooltip.closeIsProceed = true
		global.game.gameTooltip.SetTooltip(
			trans.local("ACTIONS_POPUP_TITLE"),
			trans.local("ACTIONS_POPUP_DESC"),
			funcref(self, "Unpause"))
		$Actions_Button.StartShaking()
		$Actions_Button.stopShakingOnPress = true
	
	$Project_Button.visible = false
	$ProjectProgress.visible = true
	curDays = 0
	SetProjectProgress()
	$Office.StartProject()
	$FitCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Fit"]
	$DevCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Dev"]
	$MarketCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Market"]
	for counter in counters:
		counter.Start()

func GenPoints():
	for i in range(counters.size()):
		if counters[i].present:
			if global.actionsActive[i]:
				if counters[i].bad > 0:
					CleanNegativePoint(counters[i], i)
			else:
				GenOnePoint(counters[i], i)

func GenOnePoint(counter : PointCounter, ind : int):
	var pBonus : float = global.GetInsight(ind, true)
	var nBonus : float = global.GetInsight(ind, false)
	
	var remainder = PGR + pBonus
	var negChance = clamp(NPR + nBonus, 0, NPR_limit)
	while remainder > 0:
		var pointChance = rng.randf_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		#print(counter.name, " | random number:", pointChance, " PGR:", remainder, " clamped PGR: ", temp_PGR)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			var negRandom = rng.randf_range(1, 100)
			var isGood = negRandom > negChance
			#print("NPR:", NPR + nBonus, " clamped NPR:", negChance, " random number:", negRandom)
			$Office.EnqueuePoint(counter, isGood)
		else:
			remainder = 0

func CleanNegativePoint(counter : PointCounter, ind : int):
	var remainder = PGR
	while remainder > 0:
		var pointChance = rng.randf_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		#print(counter.name, " | random number:", pointChance, " PGR:", remainder, " clamped PGR: ", temp_PGR)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			$Office.EnqueueClean(counter)
		else:
			remainder = 0

func ResetCounters():
	for counter in counters:
		counter.Reset()

func SetProjectProgress():
	$ProjectProgress.value = float(curDays) / float(global.curProject["TimeCost"]) * 100.0
	$ProjectProgress/ProjectProgressLabel.text = str(curDays) + "/" + global.curProject["TimeCost"]
	if curDays == int(global.curProject["TimeCost"]):
		$ProjectProgress.visible = false
		$Project_Button.visible = true

func SetActionProgress(i):
	$ActionProgress.value = float(actionDays) / float(global.actions[i]["TimeCost"]) * 100.0
	$ActionProgress/ActionProgressLabel.text = str(actionDays) + "/" + str(global.actions[i]["TimeCost"])
	if actionDays == int(global.actions[i]["TimeCost"]):
		global.actionsActive[0] = false
		global.actionsActive[1] = false
		global.actionsActive[2] = false
		actionDays = 0
		$ActionProgress.visible = false
		$Actions_Button.visible = true
		$Project_Button.visible = curDays >= int(global.curProject["TimeCost"])

var curDays = 0
var actionDays = 0
var curAction
func CheckTime():
	GenPoints()
	var index = -1
	for i in range(3):
		if global.actionsActive[i]:
			if index < 0:
				index = i
			else:
				index = -2
				break
	if index == -1: # no actions are active
			curDays += 1
			global.game.CheckEvents(curDays)
			if curDays == int(global.curProject["TimeCost"]):
				global.game.Overtime()
			SetProjectProgress()
	else:
		if index < 0: # all actions are active
			index = 3
		$ActionProgress.visible = true
		$Actions_Button.visible = false
		$Project_Button.visible = false
		actionDays += 1
		SetActionProgress(index)


func _on_Team_Button_buttonPressed():
	global.game.OpenTeamScreen(true)

func _on_Actions_Button_buttonPressed():
	global.game.OpenActionScreen(true)

func _on_Project_Button_buttonPressed():
	$Project_Button.visible = false
	global.game.ProjectComplete()

func Unpause():
	global.game.PauseTimer(false)
