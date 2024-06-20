extends Button

var data : Dictionary
func InitProjectButton(project):
	data = project
	$Title.text = trans.local(data["Title"])
	$Money.text = trans.local(data["MoneyCost"])
	$Time.text = trans.local(data["TimeCost"])

func _on_ProjectOption_pressed():
	global.game.soundManager.PlaySFX("Tick")
	global.curProject = data
	var desc = trans.local(data["Description"]) + "\n"
	desc += trans.local("COST") + ": " + data["MoneyCost"] + "\n"
	desc += trans.local("TIME") + ": " + data["TimeCost"]
	var callback = funcref(global.game, "StartProject")
	global.game.gameTooltip.SetTooltip(trans.local(data["Title"]), desc, callback)
