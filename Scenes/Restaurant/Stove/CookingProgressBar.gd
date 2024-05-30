extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	var raw:Color = Color("#f40d30")
	var rare:Color = Color("#D2042D")
	var med_rare:Color = Color("#F55E00")
	var well:Color = Color("#F50700")
	var burnt:Color = Color("#4B4848")
	var colorArr = [raw, rare, med_rare, well, burnt]
	
	self.fill_mode = FILL_BEGIN_TO_END


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
