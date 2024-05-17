extends Node2D


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func LoadNext(phaseName : String, path : String):
	$LoadingScreen/Label.text = "NEXT PHASE:\n" + phaseName.to_upper()
