extends Node2D

@onready var timer: Timer = $Timer

@export var spawnScenes: Array[PackedScene]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(spawn)
	randTimeStart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func randTimeStart() -> void:
	timer.start(randf_range(2.0, 20.0))

func spawn():
	if spawnScenes.is_empty():
		return
	
	var pickedScene = spawnScenes.pick_random()
	var spawnedScene = pickedScene.instantiate()
	spawnedScene.position = global_position
	get_tree().current_scene.add_child(spawnedScene)
	randTimeStart()
