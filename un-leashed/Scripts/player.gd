class_name Player
extends RigidBody2D

@export var dog: Dog

@onready var leash_anchor: Marker2D = $LeashAnchor
@onready var dash_timer: Timer = $DashTimer
@onready var yank_timer: Timer = $"../YankTimer"

@export var yankCooldown: float = 1.0
@export var acceleration: float = 2000.0
@export var maxSpeed: float = 2000.0
@export var dashForce: float = 50

var mouseDragStartPos
@export var maxYank: float = 10000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yank_timer.autostart = false
	yank_timer.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_direction != Vector2.ZERO: # True if direction is pressed
		var targetVelocity = input_direction * maxSpeed
		var velocityDifference = targetVelocity - linear_velocity
		var moveForce = velocityDifference / delta
		if Input.is_action_just_pressed("dash") and dash_timer.is_stopped():
			apply_central_force(moveForce.limit_length(acceleration * mass) * dashForce)
			dash_timer.start(3)
		else:
			apply_central_force(moveForce.limit_length(acceleration * mass))
	
	if Input.is_action_just_pressed("yank"):
		if yank_timer.is_stopped():
			mouseDragStartPos = get_global_mouse_position()
		else:
			mouseDragStartPos = null
	
	if Input.is_action_just_released("yank"):
		if mouseDragStartPos != null:
			var yankVector = mouseDragStartPos - get_global_mouse_position()
			var yankStrength: float = yankVector.length() * 50
			if yankStrength > maxYank:
				yankStrength = maxYank
			var yankDirection = yankVector.normalized() # Needed if we want directional dog yanking
			apply_central_force(yankStrength * yankDirection)
			dog.apply_central_force(yankStrength * -yankDirection)
			yank_timer.start(yankCooldown)
