extends ColorRect

func _ready():
	$CurrentPhase/Button.visible = false
	$CurrentPhase/ProgressBar.visible = false

func Start():
	$CurrentPhase/PhaseTitle.text = trans.local("NEXT_PHASE")
	$DateCounter.Start()
	$Money.Start()
	StartPhase()
	
func StartPhase():
	$CurrentPhase/Button.visible = false
	$CurrentPhase/PhaseTitle.text = trans.local(global.mainConfig["Phases"][global.curPhaseIndex]["PhaseName"])

func StartProject():
	$Money.Spend(global.curProject["MoneyCost"])
	$CurrentPhase/ProgressBar.max_value = int(global.curProject["TimeCost"])
	UpdateProgress(int(global.curProject["TimeCost"]))
	$CurrentPhase/ProgressBar.visible = true
	
func UpdateProgress(_value):
	$CurrentPhase/ProgressBar.value = clamp(_value, 0, 1000000)
	$CurrentPhase/ProgressBar/Label.text = trans.local("DAYS_LEFT") + ": " + str(_value)

func PhaseComplete():
	$CurrentPhase/ProgressBar.visible = false
	$CurrentPhase/Button.visible = true
	if (global.curPhaseIndex == 8):
		$CurrentPhase/Button.text = trans.local("FINISH_GAME")

func _on_Button_pressed():
	$CurrentPhase/Button.visible = false
	$CurrentPhase/ProgressBar.visible = false
	global.game.ProjectComplete()
