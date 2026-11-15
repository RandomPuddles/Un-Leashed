extends Label

var levelTime: int = 0
@onready var timer: Timer = $"../Timer"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	timer.autostart = true
	timer.one_shot = false
	timer.wait_time = 1
	timer.timeout.connect(onTimer)

func onTimer():
	levelTime += 1
	text = str(levelTime)
