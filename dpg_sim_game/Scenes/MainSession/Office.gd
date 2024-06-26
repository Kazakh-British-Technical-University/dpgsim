extends Node2D

var seats = []

func ResetOffice():
	$Stage.texture = load("res://Sprites/MainSession/stage1.png")

func Start():
	for i in range(2, 11):
		var mini = get_node("Worker" + str(i)) as Sprite
		mini.visible = false
		seats.append(mini)
	$Worker11.visible = false

func StartProject():
	if global.curPhaseIndex < 7:
		$Stage.texture = load("res://Sprites/MainSession/stage" + str(global.curPhaseIndex + 1) + ".png")
	else:
		$Stage.texture = load("res://Sprites/MainSession/stage7.png")
	if global.curPhaseIndex == 2:
		maxTeamSize = 4
	else:
		if global.curPhaseIndex < 2:
			maxTeamSize = 0
		else:
			maxTeamSize = 10
	UpdateMinis()

var actualTeamSize = 0
var team : Dictionary
var teamSize = 0
var maxTeamSize = 0
func UpdateMinis():
	spawnPoints.clear()
	spawnPoints.append($Worker1.global_position)
	$Worker11.visible = false
	for seat in seats:
		seat.visible = false
	
	teamSize = 0
	actualTeamSize = 0
	team = global.game.teamScreen.team.duplicate()
	for key in team:
		if key != "Management":
			actualTeamSize += team[key]
	while actualTeamSize > 0 and teamSize < maxTeamSize:
		for key in team:
			if key != "Management" and team[key] > 0 and teamSize < maxTeamSize:
				AddMiniWorker(key, seats[teamSize])
				teamSize += 1
				team[key] -= 1
				actualTeamSize -= 1
	if global.curPhaseIndex >= 3 and team["Management"] > 1:
		AddMiniWorker("Management", $Worker11)

func AddMiniWorker(worker, spot):
	spot.texture = load("res://Sprites/MainSession/Worker" + worker + ".png")
	spot.visible = true
	spawnPoints.append(spot.global_position)

###################################################
var particle = preload("res://Scenes/MainSession/PointParticle.tscn")
var particles = []
var queue = []
var cleanQueue = []

var rng = RandomNumberGenerator.new()
var spawnPoints = []

func _ready():
	rng.randomize()

var t = 0
var pointPeriod = 0.05
func _process(delta):
	ScrollClouds(delta)
	if t < pointPeriod:
		t += delta
		return
	t -= pointPeriod
	if queue.size() > 0:
		SpawnParticle(queue[0], false)
		queue.remove(0)
	if cleanQueue.size() > 0:
		SpawnParticle(cleanQueue[0], true)
		cleanQueue.remove(0)

func EnqueuePoint(counter, isGood):
	var newPoint : Dictionary
	newPoint["Counter"] = counter
	newPoint["IsGood"] = isGood
	queue.append(newPoint)

func EnqueueClean(counter):
	var newPoint : Dictionary
	newPoint["Counter"] = counter
	cleanQueue.append(newPoint)

func SpawnParticle(point, clean):
	var newParticle : PointParticle
	if particles.size() > 0:
		newParticle = particles[0]
		particles.remove(0)
		newParticle.visible = true
	else:
		newParticle = particle.instance()
		add_child(newParticle)
	
	if not clean:
		newParticle.global_position = spawnPoints[rng.randi_range(0, spawnPoints.size()-1)]
		newParticle.Launch(point)
	else:
		newParticle.Clean(point)

func ParticleFinished(oldParticle : PointParticle):
	particles.append(oldParticle)
	oldParticle.visible = false
	oldParticle.scale = Vector2.ONE

func ClearQueue():
	queue.clear()
	cleanQueue.clear()

var cloudSpeed = 5
func ScrollClouds(delta):
	$OfficeClouds.position.x -= cloudSpeed * delta
	if $OfficeClouds.position.x < -242:
		$OfficeClouds.position.x = 242

