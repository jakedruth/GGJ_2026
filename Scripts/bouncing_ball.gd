class_name BouncingBall
extends Sprite2D

@export var start_speed: float = 250.0
@export var collision_display: StatDisplay
var startBallMove: bool = false
var startDrag: bool = false
var ball_move_dir: Vector2
var ball_speed: float = 0


func _process(delta: float) -> void:
	if startBallMove:
		var collision = collision_display.get_collision()
		if not Geometry2D.is_point_in_polygon(position, collision):
			var center = collision_display.get_center();
			ball_move_dir = (center - position).normalized()
			pass

		if startDrag:
			ball_speed = lerp(ball_speed, 0.0, 1.0 - exp(-0.75 * delta))
			pass

		var step = ball_speed * delta;
		var next = position + ball_move_dir * step;
		# check to see if the next point is outside the polygon

		if not Geometry2D.is_point_in_polygon(next, collision):
			# Keep finding intersection until there are none
			var seg_flag = -1;
			var pos = position;
			while step > 0:
				for i in collision.size():
					if seg_flag == i:
						continue

					var s = collision[i];
					var e = collision[(i + 1) % collision.size()]
					var intersection = Geometry2D.segment_intersects_segment(pos, next, s, e)
					if (intersection != null):
						# print("checking collision")
						seg_flag = i;
						var segmentDirection = (e - s).normalized()
						var segmentNormal = Vector2(-segmentDirection.y, segmentDirection.x).normalized()
						var wall_distance = position.distance_to(intersection)
						step -= wall_distance
						ball_move_dir = ball_move_dir.bounce(segmentNormal).normalized()
						pos = intersection
						next = intersection + ball_move_dir * step
						i = 0
					pass
				# print("Checked all segments")
				break

		position = next;


func reset() -> void:
	startBallMove = false
	startDrag = false
	position = collision_display.get_center()
	ball_move_dir = Vector2.ZERO
	pass

func handle_start() -> void:
	if startBallMove == true:
		return
	
	startBallMove = true
	var angle = randf_range(0, TAU)
	ball_move_dir = Vector2.RIGHT.rotated(angle)
	ball_speed = start_speed
	pass
