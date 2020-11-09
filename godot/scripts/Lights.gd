extends Node2D

onready var lefttaillight = $LeftTaillight
onready var righttaillight = $RightTaillight
export var brakes = false

func _ready():
	pass
	
func _process(delta):
	if brakes:
		_taillighton()
	else:
		_taillightoff()

func _taillighton():
	lefttaillight.self_modulate.a = 1.0
	lefttaillight.scale.x = .3
	lefttaillight.scale.y = .5
	righttaillight.self_modulate.a = 1.0
	righttaillight.scale.x = .3
	righttaillight.scale.y = .5
	
func _taillightoff():
	lefttaillight.self_modulate.a = .39
	lefttaillight.scale.x = .1
	lefttaillight.scale.y = .1
	righttaillight.self_modulate.a = .39
	righttaillight.scale.x = .1
	righttaillight.scale.y = .1



