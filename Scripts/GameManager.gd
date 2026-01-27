extends Node

@export var characterStats: Stats;
@export var questStats: Stats;
@export var polygon2D: Polygon2D;

var isChar: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var poly = characterStats.to_polygon2D();
	polygon2D.polygon = poly;

	var result = characterStats.get_overlap_area_ratio(questStats)
	result = questStats.get_overlap_area_ratio(characterStats)
	print(result);

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		isChar = !isChar
		if isChar:
			polygon2D.polygon = characterStats.to_polygon2D();
		else:
			polygon2D.polygon = questStats.to_polygon2D();