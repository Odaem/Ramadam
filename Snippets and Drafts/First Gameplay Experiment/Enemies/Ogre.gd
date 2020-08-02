extends KinematicBody2D

export var target: NodePath
export var speed: float = 20
export var max_health: int = 5
var health: int
var hit_timer := 0.0
var got_hit := false
var hit_normal := Vector2(0, 0)


func _ready():
	$AnimationTree.active = true
	health = max_health


func _physics_process(delta):
	if hit_timer > 0:
		hit_timer -= delta
	
	if health <= 0:
		queue_free()
	
	if got_hit:
		move_and_slide(hit_normal * 10)
		got_hit = false
	else:
		var walk_dir := Vector2()
		if target:
			var t = get_node(target)
			if t is Node2D:
				walk_dir = (t.get_transform().get_origin() - position).normalized()
				
		if walk_dir != Vector2.ZERO:
			move_and_slide(walk_dir * speed)


func get_hit(damage: int, dir_normal: Vector2 = Vector2(0, 0), hit_timeout: float = 0.2):
	if hit_timer <= 0:
		got_hit = true
		health -= damage
		hit_normal = dir_normal
		print("got hit")