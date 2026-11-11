extends Area2D

var width_pixels := 96.0
var spike_color := Color("e96f57")


func setup(width: float, color: Color) -> void:
	width_pixels = width
	spike_color = color


func _ready() -> void:
	z_index = 3
	collision_layer = 0
	collision_mask = 1
	monitoring = true
	var hitbox := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(width_pixels, 20.0)
	hitbox.position.y = -10.0
	hitbox.shape = shape
	add_child(hitbox)
	queue_redraw()


func _draw() -> void:
	var points_per_spike := 16.0
	var count := int(width_pixels / points_per_spike)
	for index in range(count):
		var left := -width_pixels * 0.5 + float(index) * points_per_spike
		var points := PackedVector2Array([
			Vector2(left, 0.0),
			Vector2(left + points_per_spike * 0.5, -20.0),
			Vector2(left + points_per_spike, 0.0)
		])
		draw_colored_polygon(points, spike_color)
		draw_line(Vector2(left, 0.0), Vector2(left + points_per_spike, 0.0), Color("2d3038"), 2.0)
