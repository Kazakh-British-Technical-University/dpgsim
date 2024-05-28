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
	var pBonus = 0
	var nBonus = 0
	match ind:
		0:
			pBonus = global.productP
			nBonus = global.productN
		1:
			pBonus = global.techP
			nBonus = global.techN
		2:
			pBonus = global.marketP
			nBonus = global.marketN
	var remainder = PGR + pBonus
	var negChance = clamp(NPR + nBonus, 0, NPR_limit)
	while remainder > 0:
		var pointChance = rng.randi_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			var isGood = rng.randi_range(1, 100) > negChance
			$Office.EnqueuePoint(counter, isGood)
		else:
			remainder = 0
