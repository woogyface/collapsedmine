extends CPUParticles2D

@onready var smoke: CPUParticles2D = $Smoke

signal done

func fire() -> void:
	emitting = true
	smoke.emitting = true
	smoke.finished.connect(done.emit)
