extends Label

func Start():
	text = trans.local("TEAM_" + name.to_upper())
	print(name.to_upper())
	match name:
		"Management":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait01Transaprent.png")
		"Development":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait02Transaprent.png")
		"Design":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait03Transaprent.png")
		"Product":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait04Transaprent.png")
		"Marketing":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait05Transaprent.png")
		"QA":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait06Transaprent.png")
		"Support":
			$BgDefault/Portrait.texture = load("res://Sprites/Portraits/portrait07Transaprent.png")
	
	UpdateQuantity()

func _on_Plus_Button_buttonPressed():
	get_parent().HireWorker(name)
	UpdateQuantity()

func _on_Minus_Button_buttonPressed():
	get_parent().FireWorker(name)
	UpdateQuantity()

func UpdateQuantity():
	$Quantity.text = str(get_parent().team[name])
