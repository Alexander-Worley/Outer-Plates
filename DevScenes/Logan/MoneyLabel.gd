extends Label

var money = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "Pulsars: " + str(money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
		self.text = "Pulsars: " + str(money)
