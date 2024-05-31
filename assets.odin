package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Assets :: struct {
	postprocess_shader:         rl.Shader,
	generic_diffuse_shader:     rl.Shader,
	hud_diffuse_shader:         rl.Shader,
	hori_wobble_diffuse_shader: rl.Shader,
	foodtruck_model:            rl.Model,
	tentacle_model:             rl.Model,
	portal_model:               rl.Model,
	squid_meat_model:           rl.Model,
	slime_model:                rl.Model,
	fridge_model:               rl.Model,
	fridge_bones_model:         rl.Model,
	unicorn_bones_model:        rl.Model,
	lizard_hand_model:          rl.Model,
	dragon_scale_model:         rl.Model,
	plane_model:                rl.Model,
	świetlówka_model:           rl.Model,
	spoon_model:                rl.Model,
	mayo_model:                 rl.Model,
	shroom_model:               rl.Model,
	shroombox_model:            rl.Model,
	eye_model:                  rl.Model,
	bowl_model:                 rl.Model,
	wrap_model:                 rl.Model,
	radio_music:                rl.Music,
	good_ingredient_sound:      rl.Sound,
	bad_ingredient_sound:       rl.Sound,
	ding_sound:                  rl.Sound,
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
	assign_shader_to_model(a.hori_wobble_diffuse_shader, &a.fridge_bones_model)

	a.unicorn_bones_model = rl.LoadModel("res/models/ucnicorn_bone.glb")
	a.unicorn_bones_model.transform =
		rl.MatrixScale(0.6, 0.6, 0.6) *
		rl.MatrixRotateXYZ({-rl.PI / 6, rl.PI / 4, 0}) *
		rl.MatrixTranslate(0, 0.1, 0)
	assign_shader_to_model(a.hud_diffuse_shader, &a.unicorn_bones_model)

	a.lizard_hand_model = rl.LoadModel("res/models/lizard_hand.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.lizard_hand_model)

	a.dragon_scale_model = rl.LoadModel("res/models/scales.glb")
	a.dragon_scale_model.transform =
		rl.MatrixScale(0.1, 0.1, 0.1) *
		rl.MatrixRotateXYZ({-rl.PI / 6, rl.PI / 4, 0}) *
		rl.MatrixTranslate(-0.5, 0.1, 0)
	assign_shader_to_model(a.hud_diffuse_shader, &a.dragon_scale_model)

	a.plane_model = rl.LoadModel("res/models/plane.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.plane_model)

	a.świetlówka_model = rl.LoadModel("res/models/swietlowka.glb")

	a.radio_music = rl.LoadMusicStream("res/radio/radio.mp3")

	a.good_ingredient_sound = rl.LoadSound("res/sounds/correct_ingridient.mp3")
	a.bad_ingredient_sound = rl.LoadSound("res/sounds/bad_ingridient.mp3")

	a.ding_sound = rl.LoadSound("res/sounds/ding.mp3")

	a.spoon_model = rl.LoadModel("res/models/lyzka.glb")
	a.spoon_model.transform = rl.MatrixRotateXYZ({-rl.PI / 4, -6 * rl.PI / 4, 0})
	assign_shader_to_model(a.hud_diffuse_shader, &a.spoon_model)

	a.mayo_model = rl.LoadModel("res/models/sloik.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.mayo_model)

	a.shroombox_model = rl.LoadModel("res/models/mushroom_box.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.shroombox_model)

	a.shroom_model = rl.LoadModel("res/models/mushroom_solo.glb")
	assign_shader_to_model(a.hud_diffuse_shader, &a.shroom_model)

	a.eye_model = rl.LoadModel("res/models/eye_solo.glb")
	assign_shader_to_model(a.hud_diffuse_shader, &a.eye_model)

	a.bowl_model = rl.LoadModel("res/models/bowl.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.bowl_model)

	a.wrap_model = rl.LoadModel("res/models/wrap.glb")
	assign_shader_to_model(a.generic_diffuse_shader, &a.wrap_model)
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
	rl.UnloadModel(a.unicorn_bones_model)
	rl.UnloadModel(a.lizard_hand_model)
	rl.UnloadModel(a.dragon_scale_model)
	rl.UnloadModel(a.świetlówka_model)
	rl.UnloadModel(a.spoon_model)
	rl.UnloadModel(a.mayo_model)
	rl.UnloadModel(a.shroombox_model)
	rl.UnloadModel(a.shroom_model)
	rl.UnloadModel(a.eye_model)
	rl.UnloadModel(a.bowl_model)
	rl.UnloadModel(a.wrap_model)
	rl.UnloadMusicStream(a.radio_music)
	rl.UnloadSound(a.good_ingredient_sound)
	rl.UnloadSound(a.bad_ingredient_sound)
	rl.UnloadSound(a.ding_sound)
}
