@tool
extends "res://Scenes/Restaurant/PlainSurface/plainSurface.gd"

var isDispensing: bool = false
var finished: bool = false
var currentPlayer: CharacterBody2D = null
@onready var dispensingTimer = $DispensingTimer
@onready var dispensingBar = $DispensingBarControl

func _ready():
	initialize()
	dispensingTimer.start()
	dispensingTimer.paused = true

func begin_interaction(player: CharacterBody2D):
	currentPlayer = player
	if begin_dispensing():
		set_player_locks(true)
		return true
	currentPlayer = null
	finished = false
	return false


# Begin cutting
func begin_dispensing():
	if isDispensing or !currentPlayer or !currentPlayer.isHolding: return false
	if not (currentPlayer.holdableInHand).is_in_group("Glass"): return false
	if (currentPlayer.holdableInHand).get_isFull(): return false
	currentPlayer.play_animation()
	dispensingTimer.paused = false
	isDispensing = true
	dispensingBar.startMoving()
	# If already cutting or there is nothing valid to cut, return
	# Cut asynchronously
	if not dispensingTimer.is_connected("timeout", Callable(self, "_on_dispensingTimer_timeout")):
		dispensingTimer.connect("timeout", Callable(self, "_on_dispensingTimer_timeout"))
	return true

# Stop cutting
# The name of this function must remain "stop_cooking()" for code consolidation in player.gd
func stop_cooking():
	pause_dispensing()
	dispensingTimer.stop()
	dispensingTimer.start()
	dispensingBar.resetBar()
	set_player_locks(false)
	if currentPlayer:
		(currentPlayer.holdableInHand).set_isFull(finished, true)
	currentPlayer = null

func stopped_midway():
	if currentPlayer:
		(currentPlayer.holdableInHand).set_isFull(false, true)

# Finished dispensing timer
func _on_dispensingTimer_timeout():
	if currentPlayer:
		finished = true
	stop_cooking()
	begin_dispensing()

func pause_dispensing():
	dispensingTimer.paused = true
	isDispensing = false
	dispensingBar.pauseBar()

# Set player locks
func set_player_locks(isLock: bool):
	if currentPlayer:
		currentPlayer.set_is_animation_lock(isLock)
		currentPlayer.set_is_interact_lock(isLock)

func _input(event):
	# This will need to be updated in the multiplayer update. As of now, any movement from anyone will stop cutting
	if event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("up") or event.is_action_pressed("down") or event.is_action_pressed("face_left") or event.is_action_pressed("face_right") or event.is_action_pressed("face_up") or event.is_action_pressed("face_down"):
		set_player_locks(false)
		pause_dispensing()
