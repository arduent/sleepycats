extends Node

onready var road = $Road
onready var player = $Player
onready var lights = $Lights
onready var kittens = $Kittens
onready var logo = $Logo
onready var scoreboard = $ScoreBanner
onready var tombstone = $Tombstone
onready var login = $Login
onready var login_button = $LoginButton
onready var show_achievment = $Acheivement
onready var make_achievement = $MakeAchievement

var did_login = false
var gamestart = false
var showed_popup = false
var session = ""
var achievement = false

func _ready():
	make_achievement.connect("request_completed", self, "_on_request_completed")

func _on_request_completed(result, response_code, headers, body):
	show_achievment.hideme()
	
func _process(delta):
	if gamestart:
		randomize()
		road.speed_scale = player.roadspeed
		kittens.kitten_speed = player.roadspeed
		lights.position.x = player.position.x - player.half_sprite_size + 9
		lights.position.y = player.position.y - 173
		lights.brakes = player.brakes
		if kittens.hit_kitten:
			scoreboard.score -= 250
			kittens.hit_kitten = false
			kittens.dead_kitten = true
		else:
			scoreboard.score += 1
		if rand_range(0,100)>80:
			kittens.do_kitten()
		if kittens.dead_kitten:
			tombstone.position.y = kittens.position.y
			tombstone.position.x = kittens.position.x
		else:
			tombstone.position.y = -100
		if !did_login and login_button.clicked:
			showed_popup = true
			_do_login()
		if scoreboard.score >= 500:
			achievement = true
			show_achievment.showme()
			if session!="":
				make_achievement.request("https://obitcoin.org/achievement.php",["X-Session:" + str(session)])
				
	else:
		road.speed_scale = player.roadspeed
		if showed_popup:
			if login.didlogin:
				did_login = true
				showed_popup = false
				session = login.session
				player.visible = true
				lights.visible = true
				gamestart = true

func _do_login():
	did_login = true
	player.visible = false
	lights.visible = false
	gamestart = false
	login.dopop()

func _on_Timer_timeout():
	logo.queue_free();
	player.position.y = 400
	gamestart=true
	player.gamestart = true
