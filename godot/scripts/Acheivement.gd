extends Node


onready var sprite = $Sprite


func _ready():
	pass 

func showme():
	sprite.visible = true

func hideme():
	sprite.visible = false
