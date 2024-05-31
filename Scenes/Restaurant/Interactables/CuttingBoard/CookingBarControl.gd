extends Control

const COLOR = Color("#00ff00")
@onready var cuttingBarTimer = $CuttingBarTimer
@onready var progressBar = $ProgressBar
@onready var timeToCut = %CuttingTimer.wait_time * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	progressBar.max_value = timeToCut

func startMoving():
	self.visible = true
	self.set_modulate(COLOR)
	progressBar.value = 0
	cuttingBarTimer.paused = false
	cuttingBarTimer.start()

func _on_cutting_bar_timer_timeout():
	progressBar.value += 1

func pauseBar():
	cuttingBarTimer.paused = true

func resetBar():
	cuttingBarTimer.stop()
	progressBar.value = 0
	self.visible = false
