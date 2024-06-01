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
	cuttingTimer.start()
	cuttingTimer.paused = true

# Begin cutting
func begin_cutting():
	# If already cutting or there is nothing valid to cut, return
	if isCutting or !holdablesOnSurface[0] or !holdablesOnSurface[0].is_in_group("Cuttable") or holdablesOnSurface[0].isCut: return
	cuttingTimer.paused = false
	isCutting = true
	smoke.show()
	
	cuttingBar.startMoving()
	
	smoke.play()
	# Cut asynchronously
	if not cuttingTimer.is_connected("timeout", Callable(self, "_on_cuttingTimer_timeout")):
		cuttingTimer.connect("timeout", Callable(self, "_on_cuttingTimer_timeout"))

# Stop cutting
# The name of this function must remain "stop_cooking()" for code consolidation in player.gd
func stop_cooking():
	pause_cutting()
	cuttingTimer.stop()
	cuttingTimer.start()
	cuttingBar.resetBar()

func pause_cutting():
	cuttingTimer.paused = true
	isCutting = false
	smoke.hide()
	smoke.stop()
	cuttingBar.pauseBar()

# Finished cutting timer
func _on_cuttingTimer_timeout():
	stop_cooking()
	holdablesOnSurface[0].set_isCut(true)
	begin_cutting()

func _input(event):
	# This will need to be updated in the multiplayer update. As of now, any movement from anyone will stop cutting
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down") or event.is_action_pressed("face_left") or event.is_action_pressed("face_right") or event.is_action_pressed("face_up") or event.is_action_pressed("face_down"):
		pause_cutting()
