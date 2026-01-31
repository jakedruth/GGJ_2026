class_name JobPool
extends Resource

@export var jobs: Array[Job]
@export var num_jobs_to_activate: int = 1
@export var min_active_rate: float = 3
@export var max_active_rate: float = 6
var _active_rate: float
var _timer: float = 0.0

func _init() -> void:
	_active_rate = randf_range(min_active_rate, max_active_rate)

func update(job_system: JobSystem, dt: float) -> bool:
	_timer += dt;
	if _timer >= _active_rate:
		print("[", resource_path, "]: activating new job(s)")
		_timer -= _active_rate
		_active_rate = randf_range(min_active_rate, max_active_rate)
		for j in num_jobs_to_activate:
			if jobs.size() == 0:
				break
			var i: int = randi_range(0, jobs.size() - 1)
			job_system.activate_job(jobs.pop_at(i))
	return jobs.is_empty()