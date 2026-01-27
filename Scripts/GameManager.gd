extends Node

@export var characterStats: Resource;
@export var questStats: Resource;
@export var polygon2D: Polygon2D;

var isChar: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var poly = characterStats.get_polygon();
	polygon2D.polygon = poly;

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		isChar = !isChar
		if isChar:
			polygon2D.polygon = characterStats.get_polygon();
		else:
			polygon2D.polygon = questStats.get_polygon();