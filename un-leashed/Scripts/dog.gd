
extends RigidBody2D

@export var walkForce: float = 50.0
@export var runForce: float = 100.0
@export var maxSpeed: float = 2000.0

var direction: Vector2
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(onTimeout)
	randTimeStart()
	randomDirection()

func _physics_process(delta: float) -> void:
	# Continuously apply force in the dog's current direction
	if linear_velocity.length() < maxSpeed:
		apply_central_force(direction * walkForce)

# Choose a random direction for the dog to wander
func randomDirection() -> void:
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()

# Start the timer with a random duration between 2 and 5 seconds
func randTimeStart() -> void:
	timer.start(randf_range(2.0, 5.0))

# Called when the timer finishes
func onTimeout() -> void:
	randomDirection() # Pick a new direction
	randTimeStart()    # Restart the timer
