extends Node2D

signal unleashed

@export var player: Player
@export var dog: Dog
@onready var line: Line2D = $Line2D

@export var maxLength: float = 100.0
var currentLengthVector: Vector2
var currentLength: float
@export var stiffness: float = 20
@export var durability: float = 100.0
@export var maxDurability: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if !is_instance_valid(player) or !is_instance_valid(dog):
		return
	
	if get_node_or_null("Line2D") == null: # End leash logic if leash is broken
		return
	
	# Color the leash based on current durability
	updateLeashColor()
	
	currentLengthVector = dog.global_position - player.global_position # get vector from player to dog
	currentLength = currentLengthVector.length() # get float dist between player and dog
	line.points = PackedVector2Array([ # Connect ends of leash to player and dog leash-anchors
		line.to_local(player.leash_anchor.global_position),
		line.to_local(dog.leash_anchor.global_position)
		])
	
	# Leash does nothing when not stretched
	# If leash is stretched passed limit, pull person and dog towards center of leash
	if currentLength > maxLength:
		# Lower durability. lowers faster when stretched further
		durability = durability - ((currentLength - maxLength) * 0.01)
		# Pull force is larger when leash is pulled further
		var pullForce: float = (currentLength - maxLength) * stiffness
		var direction = currentLengthVector.normalized()
		player.apply_central_force(pullForce * direction)
		dog.apply_central_force(pullForce * -direction)
	else:
		# Gain durability while not stretched
		durability = durability + 0.1
		if durability > maxDurability:
			durability = maxDurability
	
	# Break leash if durability is <= 0
	if durability <= 0:
		line.queue_free()
		unleashed.emit()

func updateLeashColor():
	var damagePercent = 1.0 - (durability / maxDurability)
	line.default_color = Color.WHITE.lerp(Color.RED, damagePercent)
