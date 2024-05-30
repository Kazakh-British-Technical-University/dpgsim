extends Control

func StartPhase():
	ShowButton(false)
	$PhaseTitle.text = trans.local(global.mainConfig["Phases"][global.curPhaseIndex]["PhaseName"])
	get_node("Steps/PhaseStep" + str(global.curPhaseIndex+1)).ActiveStep()

func OverTime():
	ShowButton(true)
	get_node("Steps/PhaseStep" + str(global.curPhaseIndex+1)).CompleteStep()
	if (global.curPhaseIndex == 8):
		$PhaseTitle.text = trans.local("FINISH_GAME")
	else:
		$PhaseTitle.text = trans.local("NEXT_PHASE")

func ResetPhases():
	for child in $Steps.get_children():
		child.EmptyStep()

func ShowButton(hide):
	$Phase/NextStage.visible = hide

func _on_Button_pressed():
	ShowButton(false)
	global.game.ProjectComplete()
