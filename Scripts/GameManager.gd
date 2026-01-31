class_name GameManager
extends Node

@export var job_stat_block: StatBlock;
@export var team_stat_block: StatBlock;
@export var job_display: StatDisplay;
@export var team_display: StatDisplay;

var startBallMove: bool = false;
var startDrag: bool = false;
var ball: Node2D;
var ball_move_dir: Vector2 = Vector2.ZERO
var ball_speed: float = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team_display.stat_block = team_stat_block
	job_display.stat_block = job_stat_block

	ball = get_node("TextureRect/center/Sprite2D") as Node2D
	_reset_ball()

	var result = team_stat_block.get_overlap_area_ratio(job_stat_block)
	print(result);

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if startBallMove:
		var poly = job_stat_block.get_polygon();

		if not Geometry2D.is_point_in_polygon(ball.position, poly):
			var center = job_stat_block.get_center();
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
	ball.position = job_stat_block.get_center();
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
