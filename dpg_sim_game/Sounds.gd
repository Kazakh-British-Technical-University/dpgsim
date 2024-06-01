extends Node2D


func PlaySFX(type):
	StopAllSounds()
	match type:
		"KeyUp":
			$KeyUp.play()
		"KeyDown":
			$KeyDown.play()
		"Boop":
			$Boop.play()
		"Tick":
			$Tick.play()
		"Ching":
			$Ching.play()

func StopAllSounds():
	for sfx in get_children():
		sfx.stop()

func MusicOn(soundOn):
	if soundOn:
		$"../Music".volume_db = -20
	else:
		$"../Music".volume_db = -80

func SfxOn(soundOn):
	for sfx in get_children():
		if soundOn:
			sfx .volume_db = 0
		else:
			sfx .volume_db = -80
