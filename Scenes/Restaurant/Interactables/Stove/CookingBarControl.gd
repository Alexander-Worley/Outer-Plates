extends Control

# 0-4 colors since MAX_COOKING_LEVEL of cookable food is 4
const COLORS = {
	0: Color("#FFEA00"),
	1: Color("#ff6700"),
	2: Color("#FF0000"),
	3: Color("#8B0000"),
	4: Color("#2b2d2f")
}
@onready var cookingBarTimer = $CookingBarTimer
@onready var progressBar = $ProgressBar
@onready var timeToCook = %CookingTimer.wait_time * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	progressBar.max_value = timeToCook

func startMoving(doneness):
	self.visible = true
	self.set_modulate(COLORS[doneness])
	progressBar.value = 0
	cookingBarTimer.start()

func _on_cooking_bar_timer_timeout():
	progressBar.value += 1

func resetBar():
	cookingBarTimer.stop()
	progressBar.value = 0
	self.visible = false
