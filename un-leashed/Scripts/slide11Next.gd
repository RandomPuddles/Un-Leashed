extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(onPress)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func onPress():
	get_tree().change_scene_to_file("res://Scenes/UI/slide12.tscn")
