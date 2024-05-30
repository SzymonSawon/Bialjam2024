package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

Assets :: struct {
	foodtruck_model: rl.Model,
	squid_meat_model: rl.Model,
}

init_assets :: proc(a: ^Assets) {
	a.foodtruck_model = rl.LoadModel("res/models/foodtruck.glb")
	a.squid_meat_model = rl.LoadModel("res/models/squid_meat.glb")
}

deinit_assets :: proc(a: ^Assets) {
	rl.UnloadModel(a.foodtruck_model)
	rl.UnloadModel(a.squid_meat_model)
}
