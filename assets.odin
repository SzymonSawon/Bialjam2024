package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Assets :: struct {
	generic_diffuse_shader: rl.Shader,
	foodtruck_model:        rl.Model,
	squid_meat_model:       rl.Model,
}

init_assets :: proc(a: ^Assets) {
	a.generic_diffuse_shader = rl.LoadShader("res/shaders/vertex.glsl", "res/shaders/diffuse.glsl")
	a.foodtruck_model = rl.LoadModel("res/models/foodtruck.glb")
	a.foodtruck_model.materials[1].shader = a.generic_diffuse_shader
    fmt.printfln("MET CNT: %d", a.foodtruck_model.materialCount)
	a.squid_meat_model = rl.LoadModel("res/models/squid_meat.glb")
}

deinit_assets :: proc(a: ^Assets) {
	rl.UnloadShader(a.generic_diffuse_shader)
	rl.UnloadModel(a.foodtruck_model)
	rl.UnloadModel(a.squid_meat_model)
}
