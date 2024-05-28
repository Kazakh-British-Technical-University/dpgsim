class_name PointParticle
extends Sprite

var point
func Launch(_point):
	point = _point
	var tween = create_tween()
	if point["IsGood"]:
		modulate = Color.white
		tween.tween_property(self, "global_position", point["Counter"].goodPos, 1)
	else:
		modulate = Color.black
		tween.tween_property(self, "global_position", point["Counter"].badPos, 1)
	tween.tween_callback(self, "Ended")

func Ended():
	point["Counter"].AddPoint(point["IsGood"])
	get_parent().ParticleFinished(self)
