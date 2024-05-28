extends Button

var data : Dictionary
func InitProjectButton(project):
	data = project
	$Title.text = trans.local(data["Title"])

func _on_ProjectOption_pressed():
	global.curProject = data
	var desc = trans.local(data["Description"]) + "\n"
	desc += trans.local("COST") + ": " + data["MoneyCost"] + "\n"
	desc += trans.local("TIME") + ": " + data["TimeCost"]
	var callback = funcref(global.game, "StartProject")
	global.game.gameTooltip.SetTooltip(trans.local(data["Title"]), desc, callback)
