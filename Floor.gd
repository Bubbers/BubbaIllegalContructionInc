extends RigidBody

var mesh
var mesh_material

func _ready():
    mesh = $MeshInstance
    mesh_material = mesh.get_surface_material(0).duplicate()
    mesh_material.emission_enabled = false
    mesh.set_surface_material(0, mesh_material)

func highlight(should_highlight):
    mesh_material.emission_enabled = should_highlight
    
func retrieve_floor_mesh():
    return mesh
