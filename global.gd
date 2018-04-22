extends Node

var points = 0
var max_points = 0
var points_are_locked = false

func get_points():
    return points

func get_max_points():
    return max_points
    
func lock_points():
    points_are_locked = true
    
func unlock_points():
    points_are_locked = false
    
func set_points(points_arg):
    if !points_are_locked:
        print("set points to ", points_arg)
        points = points_arg
        max_points = max(max_points, points)

