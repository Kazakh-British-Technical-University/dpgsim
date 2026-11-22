class_name PointParticle
extends Sprite

var point
func Launch(_point):
	point = _point
	var tween = create_tween()
	modulate = Color.green if point["IsGood"] else Color.red
	tween.tween_method(self, "MoveToCounter", 0.0, 1.0, 1, [position])
	tween.tween_callback(self, "Ended")

func MoveToCounter(progress, startPos):
	var target = point["Counter"].GetPointPosition(point["IsGood"])
	position = startPos.linear_interpolate(get_parent().to_local(target), progress)

func Ended():
	point["Counter"].AddPoint(point["IsGood"])
	get_parent().ParticleFinished(self)

var rng = RandomNumberGenerator.new()
func Clean(_point):
	point = _point
	point["Counter"].CleanPoint()
	MoveFromCounter(Vector2.ZERO)
	rng.randomize()
	var offset = Vector2(rng.randi_range(-50, 50), -50)
	modulate = Color.red
	var tween = create_tween()
	tween.tween_method(self, "MoveFromCounter", Vector2.ZERO, offset, 1)
	tween.tween_method(self, "ShrinkAtOffset", Vector2.ONE, Vector2.ZERO, 0.5, [offset])
	tween.tween_callback(self, "CleanEnded")

func MoveFromCounter(offset):
	global_position = point["Counter"].GetPointPosition(false) + offset

func ShrinkAtOffset(size, offset):
	MoveFromCounter(offset)
	scale = size

func CleanEnded():
	get_parent().ParticleFinished(self)
