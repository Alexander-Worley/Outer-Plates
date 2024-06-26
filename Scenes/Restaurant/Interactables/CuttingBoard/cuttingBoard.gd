@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

var isCutting: bool = false
var currentPlayer: CharacterBody2D = null
@onready var cuttingTimer = $CuttingTimer
@onready var cuttingBar = $CuttingBarControl
@onready var smoke = %Smoke

func _ready():
	initialize()
	if side in [4, 5, 6, 7]:
		$Surface/CuttingBoard.set_frame(1)
	else: $Surface/CuttingBoard.set_frame(0)
	smoke.hide()
	smoke.stop()
	cuttingTimer.start()
	cuttingTimer.paused = true

func begin_interaction(player: CharacterBody2D):
	currentPlayer = player
	if begin_cutting():
		set_player_locks(true)
		currentPlayer.interactableBeingUsed = self
		return true
	currentPlayer = null
	return false

# Begin cutting
func begin_cutting():
	# If already cutting or there is nothing valid to cut, return
	if isCutting or !holdablesOnSurface[0] or !holdablesOnSurface[0].is_in_group("Cuttable") or holdablesOnSurface[0].isCut: return false
	currentPlayer.play_animation()
	cuttingTimer.paused = false
	isCutting = true
	smoke.show()
	
	cuttingBar.startMoving()
	
	smoke.play()
	# Cut asynchronously
	if not cuttingTimer.is_connected("timeout", Callable(self, "_on_cuttingTimer_timeout")):
		cuttingTimer.connect("timeout", Callable(self, "_on_cuttingTimer_timeout"))
	return true

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
	set_player_locks(false)
	if currentPlayer:
		currentPlayer.interactableBeingUsed = null
		currentPlayer = null

# Finished cutting timer
func _on_cuttingTimer_timeout():
	stop_cooking()
	holdablesOnSurface[0].set_isCut(true)

# Set player locks
func set_player_locks(isLock: bool):
	if currentPlayer:
		currentPlayer.set_is_animation_lock(isLock)
		currentPlayer.set_is_interact_lock(isLock)

# Triggered when the player using this cutting board moves
func move_signal():
	pause_cutting()
