extends Control

func StartPhase():
	$PhaseTitle.text = trans.local(global.mainConfig["Phases"][global.curPhaseIndex]["PhaseName"])
	get_node("Steps/PhaseStep" + str(global.curPhaseIndex+1)).ActiveStep()

func OverTime():
	ShowButton(true)
	get_node("Steps/PhaseStep" + str(global.curPhaseIndex+1)).CompleteStep()
	if (global.curPhaseIndex == 8):
		$NextStage/NextPhaseParent/NextPhase.text = trans.local("FINISH_GAME")
	else:
		$NextStage/NextPhaseParent/NextPhase.text = trans.local("NEXT_PHASE")

func ResetPhases():
	for child in $Steps.get_children():
		child.EmptyStep()

func ShowButton(hide):
	$NextStage.visible = hide

func _on_Button_pressed():
	global.game.soundManager.PlaySFX("Boop")
	global.game.ProjectComplete()

var t = 0
func _process(delta):
	t += delta
	if t > 1:
		t -= 1
	$NextStage/NextPhaseParent.scale = Vector2.ONE * lerp(1, 1.2, abs(t-0.5) * 2)
