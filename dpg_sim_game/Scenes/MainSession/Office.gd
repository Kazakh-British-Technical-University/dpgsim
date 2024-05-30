extends Node2D

var particle = preload("res://Scenes/MainSession/PointParticle.tscn")
var particles = []
var queue = []

var rng = RandomNumberGenerator.new()
var width = 100
var height = 100

func _ready():
	rng.randomize()
	width = $BG.texture.get_width()
	height = $BG.texture.get_height()

var t = 0
var pointPeriod = 0.05
func _process(delta):
	if t < pointPeriod:
		t += delta
		return
	t -= pointPeriod
	if queue.size() > 0:
		SpawnParticle(queue[0])
		queue.remove(0)

func EnqueuePoint(counter, isGood):
	var newPoint : Dictionary
	newPoint["Counter"] = counter
	newPoint["IsGood"] = isGood
	queue.append(newPoint)

func SpawnParticle(point):
	var x : float = rng.randf_range(-0.45, 0.45) * float(width)
	var y : float = rng.randf_range(-0.45, 0.45) * float(height)
	var newParticle : PointParticle
	if particles.size() > 0:
		newParticle = particles[0]
		particles.remove(0)
		newParticle.visible = true
	else:
		newParticle = particle.instance()
		add_child(newParticle)
	
	newParticle.global_position = Vector2(x, y) + global_position
	newParticle.Launch(point)

func ParticleFinished(oldParticle : PointParticle):
	particles.append(oldParticle)
	oldParticle.visible = false

func ClearQueue():
	queue.clear()
