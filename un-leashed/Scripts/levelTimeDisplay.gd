extends Label

signal winLevel

var levelTime: int = 0
@onready var timer: Timer = $"../Timer"
var winTime: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	timer.one_shot = false
	timer.wait_time = 1
	timer.timeout.connect(onTimer)
	winTime = get_tree().current_scene.winTime
	text = str(levelTime)
	timer.start()

func onTimer():
	levelTime += 1
	text = str(levelTime)
	if winTime > 0 and levelTime >= winTime:
		timer.stop()
		winLevel.emit()
