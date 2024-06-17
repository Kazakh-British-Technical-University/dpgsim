extends Node

var externalator_initated = false
var game : MainGame

var mainConfig : Dictionary
var scenarios = []
var projects = []
var events = []
var actions = []

var actionsActive = [false, false, false]
var regionsActive = [
	false,
	false,
	false,
	false,
	false,
	false,
	false
	]

var activeScenarioIndex = -1
var curPhaseIndex = -1
var curProject 

var productP = 0
var productN = 0
var techP = 0
var techN = 0
var marketP = 0
var marketN = 0
var teamInsight = 0

func ApplyInsights():
	var temp = int(global.curProject["ProductInsights"])
	if temp > 0:
		productP += temp
	else:
		productN -= temp
	temp = int(global.curProject["TechInsights"])
	if temp > 0:
		techP += temp
	else:
		techN -= temp
	temp = int(global.curProject["MarketInsights"])
	if temp > 0:
		marketP += temp
	else:
		marketN -= temp
	teamInsight += int(global.curProject["TeamInsights"])

func GetInsight(index, good):
	var insight = 0.0
	var teamBonus = 0.0
	match index:
		0:
			if good:
				insight = productP
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
			else:
				insight = productN
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
		1:
			if good:
				insight = techP
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
			else:
				insight = techN
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
		2:
			if good:
				insight = marketP
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
			else:
				insight = marketN
				teamBonus = game.teamScreen.GetTeamBonus(index, good)
	
	return insight * float(mainConfig["InsightMultiplier"]) + teamBonus

func BurnMultiplier():
	return 1 - float(mainConfig["TeamInsightBurnReductionPercent"]) * teamInsight / 100.0

func ResetGame():
	activeScenarioIndex = -1
	curPhaseIndex = -1
	productP = 0
	productN = 0
	techP = 0
	techN = 0
	marketP = 0
	marketN = 0

func curPhase():
	return scenarios[activeScenarioIndex]["PhaseProjects"][curPhaseIndex]

func curScenario():
	return scenarios[activeScenarioIndex]

