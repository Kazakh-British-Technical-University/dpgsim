class_name PointParticle
extends Sprite

var point
func Launch(_point):
	point = _point
	var tween = create_tween()
	if point["IsGood"]:
		modulate = Color.green
		tween.tween_property(self, "global_position", point["Counter"].goodPos, 1)
	else:
		modulate = Color.red
		tween.tween_property(self, "global_position", point["Counter"].badPos, 1)
	tween.tween_callback(self, "Ended")

func Ended():
	point["Counter"].AddPoint(point["IsGood"])
	get_parent().ParticleFinished(self)

var rng = RandomNumberGenerator.new()
func Clean(_point):
	point = _point
	point["Counter"].CleanPoint()
	global_position = point["Counter"].badPos
	rng.randomize()
	var finalPos = Vector2(rng.randi_range(-50, 50), -50) + global_position
	modulate = Color.red
	var tween = create_tween()
	tween.tween_property(self, "global_position", finalPos, 1)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	tween.tween_callback(self, "CleanEnded")

func CleanEnded():
	get_parent().ParticleFinished(self)
