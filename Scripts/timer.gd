extends Node

signal timeout

@onready var label = $Label
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	

func time_left():
	var time_left = timer.time_left
	var minute = floor(time_left /60)
	var seconds = int(time_left) % 60
	return [minute, seconds]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left()
	

func _on_timer_timeout() -> void:
	pass # Replace with function body.
