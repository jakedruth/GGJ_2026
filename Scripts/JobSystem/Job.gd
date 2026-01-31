class_name Job
extends Resource

signal state_changed(previous, next)

enum JobState {
	not_active,
	active,
	pre_progress,
	in_progress,
	post_progress,
	end,
}

@export var task: Task;
@export var job_icon: Texture2D;
@export var active_time: float = 5;
var _timer: float = 0;
@export var location: Vector2;
@export var max_theives: int = 1;
@export var reward: Reward
@export var failed_reward: Reward

var _job_state: JobState = JobState.not_active;

func _init() -> void:
	pass


func update(dt: float) -> JobState:
	match _job_state:
		JobState.not_active:
			pass
		JobState.active:
			_timer += dt;
			if _timer >= active_time:
				print("Job not started in time!")
				set_state(JobState.end)
			pass
		JobState.pre_progress:
			pass
		JobState.in_progress:
			pass
		JobState.post_progress:
			pass
		JobState.end:
			pass

	return _job_state
		

func get_state() -> JobState:
	return _job_state


func set_state(next: JobState) -> void:
	print("[", resource_path, "]: state changed: ", JobState.keys()[next])
	state_changed.emit(_job_state, next);
	match next:
		JobState.not_active:
			pass
		JobState.active:
			_timer = 0;
			pass
		JobState.pre_progress:
			pass
		JobState.in_progress:
			pass
		JobState.post_progress:
			pass
		JobState.end:
			pass
	_job_state = next


func _on_state_changed(previous, next):
	print("state changed: ", previous, " -> ", next);
	state_changed.emit()
