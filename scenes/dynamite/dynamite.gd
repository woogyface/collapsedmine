class_name Dynamite extends RigidBody2D

@onready var timer: Timer = $Timer
@onready var exploding_area: Area2D = $ExplodingArea
@onready var explosion: CPUParticles2D = %Explosion
@onready var dynamite: Sprite2D = $Dynamite


func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	explosion.done.connect(queue_free)
	

func _on_timeout() -> void:
	dynamite.visible = false
	var bodies := exploding_area.get_overlapping_bodies()
	if len(bodies) > 0:
		for b in bodies:
			if b.is_in_group("Rock"):
				b.queue_free()
	explosion.fire()
