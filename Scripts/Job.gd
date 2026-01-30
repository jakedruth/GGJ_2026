class_name Job
extends Resource

signal state_changed(previous, next)

enum JobState {
	not_active,
	active,
	initiated,
	in_progress,
	summary,
	end,
}

@export var task: Task;
@export var job_icon: Texture2D;
@export var active_time: float;
var _timer: float = 0;
@export var location: Vector2;
@export var max_theives: int;
@export var reward: int # FIXME
@export var failed_reward: int # FIXME
@export var add_to_pool_at_time: float;

var _job_state: JobState = JobState.not_active;

func _init() -> void:
	pass


func update(dt: float) -> void:
	match _job_state:
		JobState.not_active:
			pass
		JobState.active:
			_timer += dt;
			if _timer >= active_time:
				print("Job not started in time!")
				set_job_state(JobState.end)
			pass
		JobState.initiated:
			pass
		JobState.in_progress:
			pass
		JobState.summary:
			pass
		JobState.end:
			pass
		

func set_job_state(next: JobState) -> void:
	state_changed.emit(_job_state, next);
	match next:
		JobState.not_active:
			pass
		JobState.active:
			_timer = 0;
			pass
		JobState.initiated:
			pass
		JobState.in_progress:
			pass
		JobState.summary:
			pass
		JobState.end:
			pass
	_job_state = next


func _on_state_changed(previous, next):
	print("state changed: ", previous, " -> ", next);
	state_changed.emit()
