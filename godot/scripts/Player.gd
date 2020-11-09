extends Node2D

onready var sprite = $Sprite

var speed = 200
export var roadspeed = 2
export var brakes = false
export var gamestart = false

var screen_size
var screen_height
export var half_sprite_size = 1

func _ready():
	screen_size = get_viewport_rect().size.x
	half_sprite_size = (sprite.texture.get_width()*scale.x)/2

func _process(delta):
	if gamestart:
		if Input.is_action_pressed("ui_left"):
			position.x -= speed * delta
		elif Input.is_action_pressed("ui_right"):
			position.x += speed * delta
		elif Input.is_action_pressed("ui_down"):
			position.y += speed * delta
			brakes = true
		elif Input.is_action_pressed(("ui_up")):
			position.y -= speed * delta
			brakes = false
			if roadspeed<(2*delta):
				roadspeed = 2 * delta
		else:
			brakes = false

		position.x = clamp(position.x, half_sprite_size, screen_size - half_sprite_size)
		position.y = clamp(position.y, 490, 690)
		if position.y==690:
			roadspeed -= 1 * delta
		if position.y==490:
			roadspeed += 1 * delta
		roadspeed = clamp(roadspeed,0,10)
	
