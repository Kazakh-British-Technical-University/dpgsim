extends Control

func Start():
	$Music.Start()
	$SFX.Start()
	$Back.Start()
	UpdateSettings()

var musicOn = true
var sfxOn = true
func UpdateSettings():
	$Music/Label.text = trans.local("MUSIC") + ": "
	if musicOn:
		$Music/Label.text += trans.local("ON")
	else:
		$Music/Label.text += trans.local("OFF")
	$SFX/Label.text = trans.local("SFX") + ": "
	if sfxOn:
		$SFX/Label.text += trans.local("ON")
	else:
		$SFX/Label.text += trans.local("OFF")



func _on_Music_buttonPressed():
	musicOn = not musicOn
	UpdateSettings()
	global.game.soundManager.MusicOn(musicOn)

func _on_SFX_buttonPressed():
	sfxOn = not sfxOn
	UpdateSettings()
	global.game.soundManager.SfxOn(sfxOn)

func _on_Back_buttonPressed():
	visible = false
	$"..".ShowMainMenu(true)
