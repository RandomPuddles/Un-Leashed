class_name Player
extends RigidBody2D

@onready var leash_anchor: Marker2D = $LeashAnchor

@export var acceleration: float = 2000.0
@export var maxSpeed: float = 2000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO: # True if direction is pressed
		var targetVelocity = input_direction * maxSpeed
		var velocityDifference = targetVelocity - linear_velocity
		var moveForce = velocityDifference / delta
		apply_central_force(moveForce.limit_length(acceleration * mass))
