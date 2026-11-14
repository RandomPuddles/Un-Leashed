extends RigidBody2D

@export var acceleration: float = 2000.0
@export var maxSpeed: float = 2000.0
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomDirection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Make it so the dog wanders in a random direction that changes every 2-5 seconds, and runs at anything of interest


func randomDirection():
	direction = Vector2(randf_range(1,10),randf_range(1,10))
