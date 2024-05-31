extends Node2D

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

onready var counters = [$FitCounter, $DevCounter, $MarketCounter]
var PGR = 0
var NPR = 0
var PGR_limit = 0
var NPR_limit = 0
func Start():
	$FitCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Fit"]
	$DevCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Dev"]
	$MarketCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Market"]
	
	$FitCounter.text = trans.local("FIT_PTS")
	$DevCounter.text = trans.local("DEV_PTS")
	$MarketCounter.text = trans.local("MARKET_PTS")
	
	for counter in counters:
		counter.Start()
	
	PGR = global.mainConfig["PGR"]
	NPR = global.mainConfig["NPR"]
	PGR_limit = global.mainConfig["PGR_limit"]
	NPR_limit = global.mainConfig["NPR_limit"]

func GenPoints():
	for i in range(counters.size()):
		if counters[i].present:
			GenOnePoint(counters[i], i)

func GenOnePoint(counter : PointCounter, ind : int):
	var pBonus = global.GetInsight(ind, true)
	var nBonus = global.GetInsight(ind, false)
	
	var remainder = PGR + pBonus
	var negChance = clamp(NPR + nBonus, 0, NPR_limit)
	while remainder > 0:
		var pointChance = rng.randi_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		print(counter.name, " | random number:", pointChance, " PGR:", remainder, " clamped PGR: ", temp_PGR)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			var negRandom = rng.randi_range(1, 100)
			var isGood = negRandom > negChance
			print("NPR:", NPR + nBonus, " clamped NPR:", negChance, " random number:", negRandom)
			$Office.EnqueuePoint(counter, isGood)
		else:
			remainder = 0

func ResetCounters():
	for counter in counters:
		counter.Reset()
