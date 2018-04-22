extends Spatial

export (PackedScene) var Corner
export (PackedScene) var Straight
export (PackedScene) var Plot
export (PackedScene) var brick_floor
export (PackedScene) var wood_floor
export (int) var min_building_stack_size = 2
export (int) var max_building_stack_size = 8
export (Vector2) var target_plot = Vector2(2, 2)

signal points_changed

var points

func _ready():
    var width = 4
    var height = 4
    var block_width = 3 * (1.0 + 1.0/width)
    var block_height = 3 * (1.0 + 1.0/height)
    for x in range(10):
        for z in range(10):
            _neighborhood(Vector3(x * block_width * width, 0, z * block_height * height), width, height, Vector2(x, z))
    points = 0

func _on_Area_body_entered(body):
    points += 1
    emit_signal("points_changed", points)
    print("points are ", points)
    global.set_points(points)


func _on_Area_body_exited(body):
    points -= 1
    emit_signal("points_changed", points)
    print("points are ", points)
    global.set_points(points)



#
#   c0 s0 s1 c1
#   s7       s2
#   s6       s3
#   c3 s5 s4 c2
#
func _neighborhood(var origin, var width, var height, var plot_spot):
    var corners = [Vector3(), Vector3(), Vector3(), Vector3()]
    var mid_of_neighborhood = origin + Vector3(3 * (width / 2.0) , 0, 3 * (height / 2.0))
    
    for index in range(4):
        corners[index] = origin + Vector3(fmod(index, 2) * 3 * width, 0, (index / 2) * 3 * height)
        
    _place_straight(corners[0], width - 1, 0 * (PI /-2))
    _place_straight(corners[3], width - 1, 2 * (PI /-2))
    _place_straight(corners[1], height - 1, 1 * (PI /-2))
    _place_straight(corners[2], height - 1, 3 * (PI /-2))
    
    if plot_spot == target_plot:
        $TargetPositionHighlight.set_translation(origin + Vector3(6, 0.25, 6))
    else:
        _place_building(origin)
    
    var newPlot = Plot.instance()
    newPlot.set_translation(mid_of_neighborhood)
    newPlot.set_scale(Vector3(width * ( 1.0 - 1.0 / width ), 1.0, height * ( 1.0 - 1.0 / height )))
    add_child(newPlot)
            
func _place_building(origin):
    var block_rand = _rand_int(0, 7)
    if block_rand < 6:
        var block_type = wood_floor if block_rand < 3 else brick_floor
        var stack_size = _rand_int(min_building_stack_size, max_building_stack_size)
        
        for h in range(stack_size):
            var building_floor = block_type.instance()
            building_floor.set_translation(origin + Vector3(6, 2*h, 6))
            add_child(building_floor)
            
func _rand_int(minn, maxx):
    return randi() % (maxx - minn) + minn            
            
func _place_straight(origin, length, rotation):
    var newCorner = Corner.instance()
    newCorner.set_translation(origin)
    newCorner.rotate(Vector3(0, 1, 0), PI + rotation)
    add_child(newCorner)
    
    for number in range(1, length + 1):
        var addpos = Vector3(3, 0, 0) * (number)
        addpos = addpos.rotated(Vector3(0, 1, 0), rotation)

        var newStraight = Straight.instance()
        newStraight.set_translation(origin + addpos)
        newStraight.rotate(Vector3(0, 1, 0), (PI / 2) + rotation)
        add_child(newStraight)