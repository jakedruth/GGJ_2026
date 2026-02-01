class_name JobManager
extends Control

# Jobs move from all > open > active > removed (not existent) 
@export var all_job_pools: Array[JobPool]
@export var active_job_pools: Array[JobPool]
var active_jobs: Array[Job]
var time_multiplier: float = 1
var time_pause: bool

func _process(delta: float) -> void:
	update(delta)


func update(delta: float):
	if time_pause:
		return

	var dt = delta * time_multiplier

	if active_job_pools.size() == 0 and all_job_pools.size() > 0:
		var jobPool = all_job_pools.pop_front()
		active_job_pools.append(jobPool)
		print("[", jobPool.resource_path, "]: Adding to active job pool")

		if all_job_pools.size() == 1:
			active_job_pools.append(all_job_pools.pop_front())

	if active_job_pools.size() > 0:
		for i in range(active_job_pools.size() - 1, -1, -1):
			var empty: bool = active_job_pools[i].update(self , dt)
			if empty:
				print("[", active_job_pools[i].resource_path, "]: Removing from job pool")
				active_job_pools.remove_at(i)
	# else:
	# 	print("No active Job Pools to update")

	if active_jobs.size() > 0:
		for i in range(active_jobs.size() - 1, -1, -1):
			var state: Job.JobState = active_jobs[i].update(dt)
			if state == Job.JobState.end:
				print("Removing Job")
				active_jobs.remove_at(i)


func activate_job(job: Job):
	job.set_state(Job.JobState.active)
	active_jobs.append(job)
