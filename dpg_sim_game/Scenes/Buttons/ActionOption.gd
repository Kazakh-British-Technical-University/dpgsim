extends Button

export var index = 0
var present = true
func Start():
	$Title.text = trans.local(global.actions[index]["Title"])
	visible = present

func _on_ActionOption_pressed():
	var callback = funcref(self, "StartAction")
	global.game.gameTooltip.SetTooltip(
		trans.local(global.actions[index]["Title"]), 
		trans.local(global.actions[index]["Description"]), 
		callback
	)

func StartAction():
	get_parent().StartAction(index)
