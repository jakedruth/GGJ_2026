class_name GameManager
extends Node

@export var characterStats: StatBlock;
@export var questStats: StatBlock;
@export var questPoly: Polygon2D;
@export var teamPoly: Polygon2D;
@export var jitterRate: float;
@export var jitterRange: float;
var _jitterTimerTeam: float = 0;
var _jitterTimerQuest: float = 0;

var startBallMove: bool = false;
var startDrag: bool = false;
var ball: Node2D;
var ball_move_dir: Vector2 = Vector2.ZERO
var ball_speed: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_polygon(questPoly, questStats.get_polygon());
	_set_polygon(teamPoly, characterStats.get_polygon());

	ball = get_node("TextureRect/center/Sprite2D") as Node2D
	_reset_ball()

	var result = characterStats.get_overlap_area_ratio(questStats)
	print(result);

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_jitterTimerQuest += _delta;
	_jitterTimerTeam += _delta;
	
	if (_jitterTimerQuest > jitterRate):
		_jitterTimerQuest -= jitterRate + randf_range(0, jitterRange)
		var qp: PackedVector2Array = questStats.get_polygon();
		for i in qp.size():
			var angle = randf_range(0, TAU)
			qp[i] += Vector2.RIGHT.rotated(angle) * 0.05
		_set_polygon(questPoly, qp)
	if (_jitterTimerTeam > jitterRate):
		_jitterTimerTeam -= jitterRate + randf_range(0, jitterRange)
		var tp: PackedVector2Array = characterStats.get_polygon();
		for i in tp.size():
			var angle = randf_range(0, TAU)
			tp[i] += Vector2.RIGHT.rotated(angle) * 0.05
		_set_polygon(teamPoly, tp)

	if startBallMove:
		var poly = questStats.get_polygon();

		if not Geometry2D.is_point_in_polygon(ball.position, poly):
			var center = questStats.get_center();
			ball_move_dir = (center - ball.position).normalized()
			pass

		if startDrag:
			ball_speed = lerp(ball_speed, 0.0, 1.0 - exp(-0.75 * _delta))
			pass

		var step = ball_speed * _delta;
		var next = ball.position + ball_move_dir * step;
		# check to see if the next point is outside the polygon

		if not Geometry2D.is_point_in_polygon(next, poly):
			# Keep finding intersection until there are none
			var seg_flag = -1;
			var pos = ball.position;
			while step > 0:
				for i in poly.size():
					if seg_flag == i:
						continue

					var s = poly[i];
					var e = poly[(i + 1)%poly.size()]
					var intersection = Geometry2D.segment_intersects_segment(pos, next, s, e)
					if (intersection != null):
						print("checking collision")
						seg_flag = i;
						var segmentDirection = (e - s).normalized()
						var segmentNormal = Vector2(-segmentDirection.y, segmentDirection.x).normalized()
						var wall_distance = ball.position.distance_to(intersection)
						step -= wall_distance
						ball_move_dir = ball_move_dir.bounce(segmentNormal).normalized()
						pos = intersection
						next = intersection + ball_move_dir * step
						i = 0
					pass
				print("Checked all segments")
				break

		ball.position = next;

	pass

func _set_polygon(polygon: Polygon2D, points: PackedVector2Array) -> void:
	polygon.polygon = points;
	(polygon.get_child(0) as Line2D).points = points;
	for i in points.size():
		(polygon.get_child(i + 1) as Node2D).position = points[i];
		pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left Click
			_handle_start_ball()
			pass
		elif event.button_index == 2: # Right Click
			_reset_ball()
			pass
		elif event.button_index == 3: # Middle Click
			startDrag = true
			pass
		
	pass

func _reset_ball() -> void:
	startBallMove = false;
	startDrag = false;
	ball.position = questStats.get_center();
	ball_move_dir = Vector2.ZERO
	pass

func _handle_start_ball() -> void:
	if startBallMove == true:
		return
	
	startBallMove = true;
	var angle = randf_range(0, TAU)
	ball_move_dir = Vector2.RIGHT.rotated(angle);
	ball_speed = 20;
	pass
