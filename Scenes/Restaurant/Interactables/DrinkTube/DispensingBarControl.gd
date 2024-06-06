extends Control

const COLOR = Color("#00ff00")
@onready var dispensingBarTimer = $DispensingBarTimer
@onready var progressBar = $ProgressBar
@onready var timeToDispense = %DispensingTimer.wait_time * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	progressBar.max_value = timeToDispense
	progressBar.value = 0

func startMoving():
	self.visible = true
	self.set_modulate(COLOR)
	dispensingBarTimer.paused = false
	dispensingBarTimer.start()

func _on_dispensing_bar_timer_timeout():
	progressBar.value += 1

func pauseBar():
	dispensingBarTimer.paused = true

func resetBar():
	dispensingBarTimer.paused = true
	dispensingBarTimer.stop()
	progressBar.value = 0
	self.visible = false
