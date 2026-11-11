extends Area2D

var patrol_min := 0.0
var patrol_max := 0.0
var move_speed := 75.0
var direction := 1.0
var body_color := Color("ed805b")


func setup(left_edge: float, right_edge: float, speed: float, color: Color) -> void:
	patrol_min = left_edge
	patrol_max = right_edge
	move_speed = speed
	body_color = color


func _ready() -> void:
	z_index = 4
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	add_to_group("enemies")
	var hitbox := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(34.0, 26.0)
	hitbox.shape = shape
	add_child(hitbox)


func _process(delta: float) -> void:
	position.x += move_speed * direction * delta
	if position.x < patrol_min:
		position.x = patrol_min
		direction = 1.0
	elif position.x > patrol_max:
		position.x = patrol_max
		direction = -1.0
	queue_redraw()


func _draw() -> void:
	var bob := sin(Time.get_ticks_msec() * 0.008) * 0.8
	draw_colored_polygon(PackedVector2Array([
		Vector2(-11.0, 13.0), Vector2(-7.0, 11.0), Vector2(-1.0, 13.0),
		Vector2(5.0, 11.0), Vector2(11.0, 13.0), Vector2(14.0, 13.0),
		Vector2(9.0, 16.0), Vector2(-8.0, 16.0)
	]), Color(0.08, 0.07, 0.12, 0.42))
	var silhouette := PackedVector2Array([
		Vector2(-15.0, 10.0 + bob), Vector2(-15.0, -2.0 + bob),
		Vector2(-12.0, -9.0 + bob), Vector2(-7.0, -14.0 + bob),
		Vector2(0.0, -16.0 + bob), Vector2(8.0, -14.0 + bob),
		Vector2(13.0, -8.0 + bob), Vector2(15.0, -1.0 + bob),
		Vector2(15.0, 10.0 + bob), Vector2(9.0, 7.0 + bob),
		Vector2(4.0, 11.0 + bob), Vector2(0.0, 7.0 + bob),
		Vector2(-6.0, 11.0 + bob), Vector2(-10.0, 7.0 + bob)
	])
	draw_colored_polygon(silhouette, body_color.lightened(0.38))
	var outline := silhouette.duplicate()
	outline.append(silhouette[0])
	draw_polyline(outline, Color("302733"), 2.0)
	draw_rect(Rect2(-9.0, -7.0 + bob, 6.0, 6.0), Color("fff1c9"))
	draw_rect(Rect2(3.0, -7.0 + bob, 6.0, 6.0), Color("fff1c9"))
	var pupil_left := -7.0 if direction > 0.0 else -9.0
	var pupil_right := 5.0 if direction > 0.0 else 3.0
	draw_rect(Rect2(pupil_left, -6.0 + bob, 3.0, 4.0), Color("292634"))
	draw_rect(Rect2(pupil_right, -6.0 + bob, 3.0, 4.0), Color("292634"))
	draw_rect(Rect2(-1.0, 2.0 + bob, 3.0, 2.0), body_color.darkened(0.25))
