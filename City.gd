extends Spatial

export (PackedScene) var Corner
export (PackedScene) var Straight
export (PackedScene) var Plot

func _ready():
    var width = 4
    var height = 4
    for x in range(10):
        for z in range(10):
            _neighborhood(Vector3(1.5 + (x * 3 * width), 0, 1.5 + (z * 3 * height)), width, height)


#
#   c0 s0 s1 c1
#   s7       s2
#   s6       s3
#   c3 s5 s4 c2
#
func _neighborhood(var origin, var width, var height):
    var corners = [Vector3(), Vector3(), Vector3(), Vector3()]
    
    for index in range(4):
        corners[index] = origin + Vector3(fmod(index, 2) * 3 * width, 0, (index / 2) * 3 * height)
        
    _place_straight(corners[0], width - 1, 0 * (PI /-2))
    _place_straight(corners[3], width - 1, 2 * (PI /-2))
    _place_straight(corners[1], height - 1, 1 * (PI /-2))
    _place_straight(corners[2], height - 1, 3 * (PI /-2))

    for x in range(width - 1):
        for z in range(height - 1):
            var newPlot = Plot.instance()
            newPlot.set_translation(origin + Vector3(x * 3, 0, z * 3) + Vector3(3, 0, 3))
            add_child(newPlot)
            
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