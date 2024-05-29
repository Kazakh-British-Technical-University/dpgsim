extends Node

var externalator_initated = false
var game : MainGame

var mainConfig : Dictionary
var scenarios = []
var projects = []

var activeScenarioIndex = -1
var curPhaseIndex = -1
var curProject 

var productP = 0
var productN = 0
var techP = 0
var techN = 0
var marketP = 0
var marketN = 0

func ApplyInsights():
	var temp = int(global.curProject["ProductInsights"]) * int(mainConfig["InsightMultiplier"])
	if temp > 0:
		productP += temp
	else:
		productN -= temp
	temp = int(global.curProject["TechInsights"]) * int(mainConfig["InsightMultiplier"])
	if temp > 0:
		techP += temp
	else:
		techN -= temp
	temp = int(global.curProject["MarketInsights"]) * int(mainConfig["InsightMultiplier"])
	if temp > 0:
		marketP += temp
	else:
		marketN -= temp

func ResetGame():
	activeScenarioIndex = -1
	curPhaseIndex = -1

func curPhase():
	return scenarios[activeScenarioIndex]["PhaseProjects"][curPhaseIndex]

func curScenario():
	return scenarios[activeScenarioIndex]
