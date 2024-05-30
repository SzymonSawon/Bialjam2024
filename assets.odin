package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Assets :: struct {
	postprocess_shader:     rl.Shader,
	generic_diffuse_shader: rl.Shader,
	hud_diffuse_shader:     rl.Shader,
	hori_wobble_diffuse_shader: rl.Shader,
	foodtruck_model:        rl.Model,
	tentacle_model:         rl.Model,
	portal_model:           rl.Model,
	squid_meat_model:       rl.Model,
	slime_model:            rl.Model,
	fridge_model:           rl.Model,
	fridge_bones_model:     rl.Model,
	plane_model:                rl.Model,
	radio_music:            rl.Music,
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
	a.hori_wobble_diffuse_shader = rl.LoadShader(
		"res/shaders/vertex_wobble_horizontal.glsl",
		"res/shaders/diffuse.glsl",
	)

	a.foodtruck_model = rl.LoadModel("res/models/foodtruck.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.foodtruck_model)

	a.tentacle_model = rl.LoadModel("res/models/tentacle.glb")
	assign_shader_to_model(a.hori_wobble_diffuse_shader, &a.tentacle_model)

	a.portal_model = rl.LoadModel("res/models/portal.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.portal_model)

	a.squid_meat_model = rl.LoadModel("res/models/squid_meat.glb")
	assign_shader_to_model(a.hud_diffuse_shader, &a.squid_meat_model)

	a.slime_model = rl.LoadModel("res/models/slime.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.slime_model)

	a.fridge_model = rl.LoadModel("res/models/fridge.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.fridge_model)

	a.fridge_bones_model = rl.LoadModel("res/models/fridge_bones.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.fridge_bones_model)

	a.plane_model = rl.LoadModel("res/models/plane.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.plane_model)

	a.radio_music = rl.LoadMusicStream("res/radio/radio.mp3")
}

deinit_assets :: proc(a: ^Assets) {
	rl.UnloadShader(a.postprocess_shader)
	rl.UnloadShader(a.hud_diffuse_shader)
	rl.UnloadShader(a.generic_diffuse_shader)
	rl.UnloadModel(a.foodtruck_model)
	rl.UnloadModel(a.tentacle_model)
	rl.UnloadModel(a.portal_model)
	rl.UnloadModel(a.squid_meat_model)
	rl.UnloadModel(a.slime_model)
	rl.UnloadModel(a.fridge_model)
	rl.UnloadModel(a.fridge_bones_model)
}
