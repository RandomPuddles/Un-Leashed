extends Node2D

@export var winTime: float
@onready var level_timer: Label = $Player/LevelTimer/Label
@onready var leash: Node2D = $Leash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_timer.winLevel.connect(onWin)
	leash.unleashed.connect(onUnleashed)


func onWin():
	print("You won the level!")

func onUnleashed():
	print("UN-LEASHED THE BEAST")
