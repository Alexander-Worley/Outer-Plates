@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

var isCutting: bool = false
@onready var cuttingTimer = $CuttingTimer
@onready var cuttingBar = $CuttingBarControl
@onready var smoke = %Smoke

func _ready():
	initialize()
	smoke.hide()
	smoke.stop()

# Begin cutting
func begin_cutting():
	print("Entered begin_cutting")
	# If already cutting or there is nothing valid to cut, return
	if isCutting or !holdablesOnSurface[0] or !holdablesOnSurface[0].is_in_group("Cuttable") or holdablesOnSurface[0].isCut: return
	print("Cutting has begun")
	cuttingTimer.paused = false
	cuttingTimer.start()
	isCutting = true
	smoke.show()
	
	cuttingBar.startMoving()
	
	smoke.play()
	# Cook asynchronously
	if not cuttingTimer.is_connected("timeout", Callable(self, "_on_cuttingTimer_timeout")):
		cuttingTimer.connect("timeout", Callable(self, "_on_cuttingTimer_timeout"))

# Stop cutting
func stop_cooking():
	print("Entered stop_cooking")
	if !isCutting: return
	print("Cutting has stopped")
	cuttingTimer.paused = true
	cuttingBar.pauseBar()
	isCutting = false
	smoke.hide()
	smoke.stop()

# Finished cutting timer
func _on_cuttingTimer_timeout():
	print("Cutting has finished")
	stop_cooking()
	cuttingTimer.stop()
	cuttingBar.resetBar()
	holdablesOnSurface[0].increase_doneness()
	begin_cutting()

func _input(event):
	# This will need to be updated in the multiplayer update. As of now, any movement from anyone will stop cutting
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down") or event.is_action_pressed("face_left") or event.is_action_pressed("face_right") or event.is_action_pressed("face_up") or event.is_action_pressed("face_down"):
		stop_cooking()
