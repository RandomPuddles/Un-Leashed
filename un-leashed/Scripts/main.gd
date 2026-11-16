extends Node2D

@export var winTime: float
@onready var level_timer: Label = $Player/LevelTimer/Label
@onready var leash: Node2D = $Leash

var sceneName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_timer.winLevel.connect(onWin)
	leash.unleashed.connect(onUnleashed)
	sceneName = get_tree().current_scene.scene_file_path.get_file()


func onWin():
	if sceneName == "map1.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/slide5.tscn")
	elif sceneName == "map2.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/slide9.tscn")
	elif sceneName == "map3.tscn":
		get_tree().change_scene_to_file("res://Scenes/UI/slide13.tscn")
	else:
		pass

func onUnleashed():
	print("UN-LEASHED THE BEAST")
