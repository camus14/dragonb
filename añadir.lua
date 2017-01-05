-----------------------------------------------------------------------el altar

local mesadragon_formspec =
	"size[8,8.5]"..
	default.gui_bg..
	default.gui_bg_img..
	default.gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
--	"image[2.75,1.5;1,1;default_furnace_fire_bg.png]"..
	"image[3.75,1.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,1.5;2,2;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	default.get_hotbar_bg(0, 4.25)

local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	if listname == "fuel" then
		if stack:get_name() == "dragonb:escamasd" then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

minetest.register_node("dragonb:altardragon", {
	description = "Altar dragon",
	tiles = {
		"dragonb_altaruno.png",
		"dragonb_radardos.png",
		"dragonb_altartres.png",
		"dragonb_altartres.png",
		"dragonb_altartres.png",
		"dragonb_altartres.png",
	    },
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", mesadragon_formspec)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 1)
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local srclist = inv:get_list("src")
		local fuellist = inv:get_list("fuel")
--		minetest.chat_send_all(srclist[1]:get_name())
		if fuellist[1]:get_name() == "dragonb:escamasd" then
			if srclist[1]:get_name() == "default:pick_diamond" then
				if inv:room_for_item("dst", "dragonb:picodragon") then
					inv:add_item("dst", "dragonb:picodragon")
				end			
			elseif srclist[1]:get_name() == "default:shovel_diamond" then
				if inv:room_for_item("dst", "dragonb:paladragon") then
					inv:add_item("dst", "dragonb:paladragon")
				end
			elseif srclist[1]:get_name() == "default:axe_diamond" then
				if inv:room_for_item("dst", "dragonb:hachadragon") then
					inv:add_item("dst", "dragonb:hachadragon")
				end
			end
		end
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		if listname == "dst" then
--			minetest.chat_send_all("todo bien")
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local srclist = inv:get_list("src")
			local fuellist = inv:get_list("fuel")
			srclist[1]:take_item()
			inv:set_stack("src", 1, srclist[1])
			fuellist[1]:take_item()
			inv:set_stack("fuel", 1, fuellist[1])
		else
--			minetest.chat_send_all("muy mal")
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local dstlist = inv:get_list("dst")
			dstlist[1]:take_item()
			inv:set_stack("dst", 1, dstlist[1])
		end
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local srclist = inv:get_list("src")
		local fuellist = inv:get_list("fuel")
--		minetest.chat_send_all(srclist[1]:get_name())
		if fuellist[1]:get_name() == "dragonb:escamasd" then
			if srclist[1]:get_name() == "default:pick_diamond" then
				if inv:room_for_item("dst", "dragonb:picodragon") then
					inv:add_item("dst", "dragonb:picodragon")
				end			
			elseif srclist[1]:get_name() == "default:shovel_diamond" then
				if inv:room_for_item("dst", "dragonb:paladragon") then
					inv:add_item("dst", "dragonb:paladragon")
				end
			elseif srclist[1]:get_name() == "default:axe_diamond" then
				if inv:room_for_item("dst", "dragonb:hachadragon") then
					inv:add_item("dst", "dragonb:hachadragon")
				end
			end
		end
	end,
	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})

-----------------------------------------------------------------------las escamas

minetest.register_node("dragonb:escamas_en_piedra", {
	description = "Escamas de dragon en piedra",
	tiles = {"default_stone.png^dragonb_escamas_en_piedra.png"},
	groups = {cracky = 3, level = 3},
	drop = "dragonb:escamasd",
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craftitem("dragonb:escamasd", {
	description = "Escamas de dragon",
	inventory_image = "dragonb_escamas_dragon.png",
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "dragonb:escamas_en_piedra",
	wherein        = "default:stone",
	clust_scarcity = 8 * 8 * 8,
	clust_num_ores = 2,
	clust_size     = 3,
	y_min          = 1025,
	y_max          = 31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "dragonb:escamas_en_piedra",
	wherein        = "default:stone",
	clust_scarcity = 32 * 32 * 32,
	clust_num_ores = 2,
	clust_size     = 6,
	y_min          = -31000,
	y_max          = 64,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "dragonb:escamas_en_piedra",
	wherein        = "default:stone",
	clust_scarcity = 64 * 64 * 64,
	clust_num_ores = 3,
	clust_size     = 12,
	y_min          = -31000,
	y_max          = 0,
})

-----------------------------------------------------------------------las herramientas

minetest.register_tool("dragonb:picodragon", {
	description = "Pico del dragon",
	inventory_image = "dragonb_picodragon.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=3,
		groupcaps={
			cracky = {times={[1]=1.0, [2]=0.7, [3]=0.20}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=5},
	},
})

minetest.register_tool("dragonb:paladragon", {
	description = "Pala del dragon",
	inventory_image = "dragonb_paladragon.png",
	wield_image = "dragonb_paladragon.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			crumbly = {times={[1]=0.70, [2]=0.30, [3]=0.10}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=4},
	},
})

minetest.register_tool("dragonb:hachadragon", {
	description = "Hacha del dragon",
	inventory_image = "dragonb_hachadragon.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=1.40, [2]=0.60, [3]=0.20}, uses=20, maxlevel=2},
		},
		damage_groups = {fleshy=7},
	},
})
