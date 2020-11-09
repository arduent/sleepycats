extends Node2D

onready var kitten = $Kittens
onready var kittensprite = $KittenSprite

const SPEED = 180
export var kitten_speed = 0
export var hit_kitten = false
export var dead_kitten = false

var kitten_in_the_road = false
var screen_size
var screen_height

func _ready():
	connect("body_entered",self,"_on_body_entered")
	screen_size = get_viewport_rect().size.x
	screen_height = get_viewport_rect().size.y
	visible = false
	
func do_kitten():
	if !kitten_in_the_road:
		randomize()
		kitten_in_the_road = true
		var kitten_grid_x = (randi()%7) * 512
		var kitten_grid_y = (randi()%27+1) * 512
		kittensprite.region_rect.position.x = kitten_grid_x
		kittensprite.region_rect.position.y = kitten_grid_y
		position.y = -100
		position.x = rand_range(50,screen_size-50)
		visible = true
		dead_kitten = false

func _process(delta):
	if kitten_in_the_road:
		position.y += kitten_speed * SPEED * delta;
		if position.y > screen_height:
			kitten_in_the_road = false
			visible = false

func _on_body_entered(body):
	print(body)
	if body.name == "Player":
		hit_kitten = true
