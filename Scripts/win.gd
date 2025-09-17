extends Node2D

@onready var label = $Label
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	label.text = "%02d:%02d" % time_left()
	pass

# update text by calculating time left
func time_left():
	var time_left_ = timer.time_left
	var minute = floor(time_left_ /60)
	var seconds = int(time_left_) % 60
	return [minute, seconds]


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	pass # Replace with function body.
