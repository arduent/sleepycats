extends Node

onready var score_board = $ScoreBoard
export var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	score_board.text = str(score)
