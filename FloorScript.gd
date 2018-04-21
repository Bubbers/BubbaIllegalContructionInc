extends MeshInstance

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    var material = self.get_surface_material(0).duplicate()
    material.emission_enabled = false
    self.set_surface_material(0, material)
    
