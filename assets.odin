package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Assets :: struct {
	postprocess_shader:     rl.Shader,
	generic_diffuse_shader: rl.Shader,
	hud_diffuse_shader: rl.Shader,
	foodtruck_model:        rl.Model,
	squid_meat_model:       rl.Model,
}

assign_shader_to_model :: proc(s: rl.Shader, m: ^rl.Model) {
	for &mat in m.materials[0:m.materialCount] {
		mat.shader = s
	}
}

init_assets :: proc(a: ^Assets) {
	a.postprocess_shader = rl.LoadShader(nil, "res/shaders/postprocess.glsl")
	a.hud_diffuse_shader = rl.LoadShader("res/shaders/vertex.glsl", "res/shaders/diffuse_hud.glsl")
	a.generic_diffuse_shader = rl.LoadShader("res/shaders/vertex.glsl", "res/shaders/diffuse.glsl")

	a.foodtruck_model = rl.LoadModel("res/models/foodtruck.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.foodtruck_model)

	a.squid_meat_model = rl.LoadModel("res/models/squid_meat.glb")
	assign_shader_to_model(a.hud_diffuse_shader, &a.squid_meat_model)
}

deinit_assets :: proc(a: ^Assets) {
	rl.UnloadShader(a.postprocess_shader)
	rl.UnloadShader(a.hud_diffuse_shader)
	rl.UnloadShader(a.generic_diffuse_shader)
	rl.UnloadModel(a.foodtruck_model)
	rl.UnloadModel(a.squid_meat_model)
}
