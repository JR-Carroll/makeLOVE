ATL = require("AdvTiledLoader")
ATL.Loader.path = "maps/"

function makeLevel(lvl)
	map = {}
		map.map = ATL.Loader.load("regular_room.tmx")
		map.x = 0
		map.y = menu_offset
		map.going_x = 0
		map.going_y = map.y
		map.direction = ""

		map.level = create_map(lvl)
	print("Level: "..lvl)
	print("  1 2 3 4 5 6 7 8")
	for i = 1, #map.level, 1 do
		io.write(i.." ")
		for e = 1, #map.level[1] do
			io.write(map.level[i][e])
			io.write(" ")
		end
		print("")
	end
	print("")
	map = placeDoors(map)
	map = placeFloors(map)
	-- Move it to the Start Room
	map.going_y = (((start_room[1] * 352) - 352) * -1) + menu_offset
	map.going_x = ((start_room[2] * 512) - 512) * -1
end

function addFloor(map, room_loc, style)
	local tiles = {}
	local floortiles = {}
	local tilex = 0
	local tiley = 0
	local randomtiles = {}
	floortiles["normal"] = {{"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"},
												  {"T","T","T","T","T","T","T","T","T","T","T","T"}}
	
	floortiles["hidden"] = {{"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"},
												  {"D","D","D","D","D","D","D","D","D","D","D","D"}}

	floortiles["cross"] =  {{"T","T","H","H","H","H","H","H","H","H","T","T"},
												  {"L","L","T","T","H","H","H","H","T","T","L","L"},
												  {"H","H","L","L","T","H","H","T","L","L","H","H"},
												  {"H","H","H","H","L","T","T","L","H","H","H","H"},
												  {"H","H","H","H","T","L","L","T","H","H","H","H"},
												  {"H","H","T","T","L","H","H","L","T","T","H","H"},
												  {"T","T","L","L","H","H","H","H","L","L","T","T"}}

	floortiles["start"] = {{"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","D","D","T","T","T","T","T"},
												 {"T","T","T","D","T","D","D","T","D","T","T","T"},
												 {"T","T","T","D","D","D","D","D","D","T","T","T"}}
												 
	floortiles["shop"] = {{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"},
												{"C","C","C","C","C","C","C","C","C","C","C","C"}}
	
	randomtiles = 			 {{{"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","L","L","L","T","T","T","T","L","L","L","T"},
												 {"T","H","T","T","T","T","T","T","T","T","H","T"},
												 {"T","H","T","L","L","L","L","L","L","T","H","T"},
												 {"T","H","T","T","T","T","T","T","T","T","H","T"},
												 {"T","H","L","L","T","T","T","T","L","L","H","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"}},
	
												{{"H","H","H","H","H","T","T","H","H","H","H","H"},
												 {"H","T","T","T","H","T","T","T","T","H","T","H"},
												 {"H","T","L","T","H","T","L","L","T","H","T","H"},
												 {"T","T","H","T","H","T","T","H","T","H","T","T"},
												 {"L","T","H","T","H","L","T","H","T","H","T","L"},
												 {"H","T","H","T","T","T","T","H","T","T","T","H"},
												 {"H","L","H","L","L","T","T","H","L","L","L","H"}},
	
												{{"H","H","H","H","H","T","T","H","H","H","H","H"},
												 {"H","T","T","T","T","T","T","T","T","T","T","H"},
												 {"H","T","L","L","L","T","T","L","L","L","T","H"},
												 {"T","T","H","T","T","T","T","T","T","H","T","T"},
												 {"L","T","H","L","L","T","T","L","L","H","T","L"},
												 {"H","T","T","T","T","T","T","T","T","T","T","H"},
												 {"H","L","L","L","L","T","T","L","L","L","L","H"}},
	
												{{"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","L","L","L","L","T","T","L","L","L","L","T"},
												 {"T","H","T","T","T","T","T","T","T","T","H","T"},
												 {"T","H","T","T","T","T","T","T","T","T","H","T"},
												 {"T","H","T","T","T","T","T","T","T","T","H","T"},
												 {"T","H","L","L","L","T","T","L","L","L","H","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"}},
												 
												{{"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"},
												 {"T","T","T","T","T","T","T","T","T","T","T","T"}}}
	
	for id, tile in pairs(map.map.tiles) do
		if tile.properties.name then
			tiles[tile.properties.name] = tile
		end
	end

	for i = 2 + (11 * (room_loc[2] - 1)), 8 + (11 * (room_loc[2] - 1)), 1 do -- row
		tiley = tiley + 1
		tilex = 0
		for e = 2 + (16 * (room_loc[1] - 1)), 13 + (16 * (room_loc[1] - 1)), 1 do -- column
			tilex = tilex + 1
			if type(style) == "string" then
				map.map("Floor"):set(e ,i, tiles[floortiles[style][tiley][tilex]])
			else
				map.map("Floor"):set(e ,i, tiles[randomtiles[style][tiley][tilex]])
			end
		end
	end

	return map
end

function addDoor(map, room_loc, door_type, direction)
	local tiles = {}
	for id, tile in pairs(map.map.tiles) do
		if tile.properties.name then
			tiles[tile.properties.name] = tile
		end
	end
	if direction == "S" then
		if door_type == "W" then
			map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 10 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."1"])
			map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 10 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."2"])
		else
			map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 10 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."1"])
			map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 10 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."2"])
		end
		map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 9 +  (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."1"])
		map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 9 +  (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."2"])
	end

	if direction == "N" then
		if door_type == "W" then --wall
			map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 0 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."1"])
			map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 0 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."2"])
		else
			map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 0 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."1"])
			map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 0 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."2"])
		end
		map.map("Objects"):set(7 + (16 * (room_loc[2] - 1)), 1 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."1"])
		map.map("Objects"):set(8 + (16 * (room_loc[2] - 1)), 1 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."2"])
	end
	
	if direction == "W" then
		if door_type == "W" then
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."1"])
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."2"])
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."3"])
		else
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."1"])
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."2"])
			map.map("Objects"):set(0 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."3"])
		end
		map.map("Objects"):set(1 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."1"])
		map.map("Objects"):set(1 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."2"])
		map.map("Objects"):set(1 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."3"])
	end

	if direction == "E" then
		if door_type == "W" then
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."1"])
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."2"])
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."T"..door_type.."3"])
		else
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."1"])
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."2"])
			map.map("Objects"):set(15 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."T".."D".."3"])
		end
		map.map("Objects"):set(14 + (16 * (room_loc[2] - 1)), 4 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."1"])
		map.map("Objects"):set(14 + (16 * (room_loc[2] - 1)), 5 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."2"])
		map.map("Objects"):set(14 + (16 * (room_loc[2] - 1)), 6 + (11 * (room_loc[1] - 1)), tiles[direction.."B"..door_type.."3"])
	end
	return map
end

function placeDoors(map)
	for i = 1, #map.level, 1 do -- row
		for e = 1, #map.level[1] do --column
			if map.level[i][e] == "." or map.level[i][e] == "h" or map.level[i][e] == "H" then
				map = addDoor(map, {i,e}, "W", "N")
				map = addDoor(map, {i,e}, "W", "S")
				map = addDoor(map, {i,e}, "W", "E")
				map = addDoor(map, {i,e}, "W", "W")
			else
				--check north for connecting room
				if map.level[i - 1] and map.level[i - 1][e] then
					check = map.level[i - 1][e]
				else
					check = nil
				end
				checkConnectingRooms(check, i, e, "N")
				--check south for connecting room
				if map.level[i + 1] and map.level[i + 1][e] then
					check = map.level[i + 1][e]
				else
					check = nil
				end
				checkConnectingRooms(check, i, e, "S")
				--check west for connecting room
				if map.level[i] and map.level[i][e - 1] then
					check = map.level[i][e - 1]
				else
					check = nil
				end
				checkConnectingRooms(check, i, e, "W")
				--check east for connecting room
				if map.level[i] and map.level[i][e + 1] then
					check = map.level[i][e + 1]
				else
					check = nil
				end
				checkConnectingRooms(check, i, e, "E")
			end
		end
	end
	return map
end
															--check					i				e		"east"/"west"...
function checkConnectingRooms(room_to_check, roomx, roomy, roomloc)
	if room_to_check == nil or room_to_check == "." then
		map = addDoor(map, {roomx ,roomy}, "W", roomloc)
	end
	if room_to_check ~= nil and room_to_check ~= "." then
		if room_to_check == "R" or room_to_check == "B" or room_to_check == "T" or room_to_check == "A" or room_to_check == "C" or room_to_check == "S" then
			if map.level[roomx][roomy] ~= "h" or map.level[roomx][roomy] ~= "H" then
				map = addDoor(map, {roomx ,roomy}, "O", roomloc)
			else
				map = addDoor(map, {roomx ,roomy}, "W", roomloc)
			end
		end
		if room_to_check == "$" or room_to_check == "Y" or room_to_check == "D" then
			if map.level[roomx][roomy] ~= "h" or map.level[roomx][roomy] ~= "H" then
				map = addDoor(map, {roomx ,roomy}, "L", roomloc)
			else
				map = addDoor(map, {roomx ,roomy}, "W", roomloc)
			end
		end
		if room_to_check == "h" or room_to_check == "H" then
			map = addDoor(map, {roomx ,roomy}, "W", roomloc)
		end
	end
end

function placeFloors(map)
	for i = 1, #map.level, 1 do
		for e = 1, #map.level[1] do
			--default to empty
			addFloor(map, {e,i}, "normal")

			if map.level[i][e] == "." then
				addFloor(map, {e,i}, "cross")
			end
			if map.level[i][e] == "$" then
				addFloor(map, {e,i}, "shop")
			end
			if map.level[i][e] == "R" then
				-- Choose a random floor layout
				arnd = math.random(1, 100)
				if arnd > 80 then
					rndtile = math.random(1,5)
					addFloor(map, {e,i}, rndtile)
				else
					addFloor(map, {e,i}, "normal")
				end
			end
			if map.level[i][e] == "S" then
				addFloor(map, {e,i}, "start")
			end
			if map.level[i][e] == "B" then
				addFloor(map, {e,i}, "normal")
			end
			if map.level[i][e] == "H" or map.level[i][e] == "h" then
				addFloor(map, {e,i}, "hidden")
			end
		end
	end
	return map
end

function move_rooms(dir)
	if dir == "up" then
		map.going_y = map.going_y + 352
	end
	if dir == "down" then
		map.going_y = map.going_y - 352
	end
	if dir == "left" then
		map.going_x = map.going_x + 512
	end
	if dir == "right" then
		map.going_x = map.going_x - 512
	end
end