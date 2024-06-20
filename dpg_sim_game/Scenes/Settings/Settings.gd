extends Control

func Start():
	$Music.Start()
	$SFX.Start()
	$Back.Start()
	UpdateSettings()

func UpdateSettings():
	$Music/Label.text = trans.local("MUSIC") + ": "
	if global.musicOn:
		$Music/Label.text += trans.local("ON")
	else:
		$Music/Label.text += trans.local("OFF")
	$SFX/Label.text = trans.local("SFX") + ": "
	if global.sfxOn:
		$SFX/Label.text += trans.local("ON")
	else:
		$SFX/Label.text += trans.local("OFF")



func _on_Music_buttonPressed():
	global.musicOn = not global.musicOn
	UpdateSettings()
	global.game.soundManager.MusicOn(global.musicOn)

func _on_SFX_buttonPressed():
	global.sfxOn = not global.sfxOn
	UpdateSettings()
	global.game.soundManager.SfxOn(global.sfxOn)

func _on_Back_buttonPressed():
	visible = false
	$"..".ShowMainMenu(true)
