extends Node

export var session = ""
export var didlogin = false
onready var window =  $WindowDialog
onready var code = $WindowDialog/Code
onready var mobile = $WindowDialog/Mobile
onready var send_mobile = $SendMobile
onready var send_code = $SendCode
onready var button = $WindowDialog/SubmitButton
onready var label = $WindowDialog/TextEdit

var first_step = false

# Called when the node enters the scene tree for the first time.
func _ready():
	send_mobile.connect("request_completed", self, "_on_request_completed")
	send_code.connect("request_completed", self, "_on_code_completed")

func dopop():
	window.popup()

func _on_request_completed(result, response_code, headers, body):
	var codestr = body.get_string_from_utf8()
	code.visible = true
	code.text = codestr
	button.text = "Log In"

func _on_code_completed(result, response_code, headers, body):
	var res = JSON.parse(body.get_string_from_utf8())
	if typeof(res.result) == TYPE_ARRAY:
		session = res.result[0]
		var msg = res.result[1]
		label.text = msg
		didlogin = true

func _on_ToolButton_pressed():
	if !first_step:
		first_step = true
		send_mobile.request("https://obitcoin.org/login1.php",["X-Mobile-Number:" + str(mobile.text)])
	else:
		send_code.request("https://obitcoin.org/login2.php",["X-Mobile-Number:" + str(mobile.text),"X-Code:" + str(code.text)])
