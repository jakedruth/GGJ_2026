extends Node

@export var characterStats: Stats;
@export var questStats: Stats;
@export var questPoly: Polygon2D;
@export var teamPoly: Polygon2D;
@export var jitterRate: float;
@export var jitterRange: float;
var _jitterTimerTeam: float = 0;
var _jitterTimerQuest: float = 0;

var isChar: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_polygon(questPoly, questStats.to_polygon2D());
	_set_polygon(teamPoly, characterStats.to_polygon2D());

	var result = characterStats.get_overlap_area_ratio(questStats)
	print(result);

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_jitterTimerQuest += _delta;
	_jitterTimerTeam += _delta;
	
	if (_jitterTimerQuest > jitterRate):
		_jitterTimerQuest -= jitterRate + randf_range(0, jitterRange)
		var qp: PackedVector2Array = questStats.to_polygon2D();
		for i in qp.size():
			var angle = randf_range(0, TAU)
			qp[i] += Vector2.RIGHT.rotated(angle) * 0.05
		_set_polygon(questPoly, qp)
	if (_jitterTimerTeam > jitterRate):
		_jitterTimerTeam -= jitterRate + randf_range(0, jitterRange)
		var tp: PackedVector2Array = characterStats.to_polygon2D();
		for i in tp.size():
			var angle = randf_range(0, TAU)
			tp[i] += Vector2.RIGHT.rotated(angle) * 0.05
		_set_polygon(teamPoly, tp)

	pass

func _set_polygon(polygon: Polygon2D, points: PackedVector2Array) -> void:
	polygon.polygon = points;
	(polygon.get_child(0) as Line2D).points = points;