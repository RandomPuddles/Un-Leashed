extends Timer

var levelTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	one_shot = false
	wait_time = 1
	autostart = true
	timeout.connect(onTimeout)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func onTimeout():
	levelTimer = int(levelTimer + wait_time)
