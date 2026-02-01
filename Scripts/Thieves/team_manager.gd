class_name TeamManager
extends Control

@export var team: Array[Thief]
@export var h_box: HBoxContainer
const thief_display = preload("res://Scenes/thief_mini_display.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for thief in team:
		var display: ThiefMiniDisplay = thief_display.instantiate()
		display.thief = thief
		display.pressed.connect(_on_thief_pressed.bind(display))
		h_box.add_child(display)
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for thief in team:
		thief.update(delta)
		pass
	pass


func _on_thief_pressed(display: ThiefMiniDisplay):
	print("Pressed: ", display.thief.name)
	get_parent().call("set_current_team", display.thief.stat_block)
	pass
