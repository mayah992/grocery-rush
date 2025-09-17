class_name State_Sprint extends State

@export var move_speed : float = 20.0

@onready var idle : State = $"../Idle"

# what happens when the player enters this state
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass
	
func Exit() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	if Input.is_action_pressed("sprint"):
		move_speed = 70.0
	else:
		move_speed = 20.0
		
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
		
	return null
	
func Physics(_delta : float) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
