extends Node2D

@export var winTime: float
@onready var level_timer: Label = $Player/LevelTimer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_timer.winLevel.connect(onWin)


func onWin():
	print("You won the level!")
