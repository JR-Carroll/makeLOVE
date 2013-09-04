function create_map(lvl)
	-- S = Start Room
	-- T = Treasure Room
	-- B = Boss Room
	-- $ = Shop Room
	-- C = Battle Room
	-- H = Hidden Room
	-- h = Secret Hidden Room
	-- A = Sacrafice Room
	-- Y = Library Room
	-- D = Arcade Room

	required_rooms = {"$","B","T","h"}
	extra_rooms = {"H"}
	optional_rooms = {"A","Y","D","C"}
	regular_rooms = {}
	room_loop = 0
	
	map.current_tile_x = 0
	map.current_tile_y = 0
	map.new_tile_x = 0
	map.new_tile_y = 0
	map.minimaprooms = {{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"},
											{"1","1","1","1","1","1","1","1"}}
	
	for i = 1, lvl + 4, 1 do
		table.insert(regular_rooms, "R")
	end
	map.level = { {".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."},
								{".",".",".",".",".",".",".","."}}
	-- Set the Start Room
	start_room = {math.random(1,8),math.random(1, 8)}
	map.level[start_room[1]][start_room[2]] = "S"
	
	--Add Regular Rooms
	while #regular_rooms > 0 do
		--print("Adding Regular Rooms"..#regular_rooms)
		current_room = pick_random_room(map)
		open_locations = check_locations(current_room, "regular", map)
		if #open_locations > 0 then
			door_location = open_locations[math.random(1, #open_locations)]
			current_room = move_room(current_room, door_location)
			map.level[current_room[1]][current_room[2]] = "R"
			table.remove(regular_rooms, 1)
		else
			room_loop = room_loop + 1
			if room_loop > 100 then
				create_map(lvl)
			end
		end
	end
	room_loop = 0
	--Add Required Rooms
	while #required_rooms > 0 do
		--print("Adding Required Rooms"..#required_rooms)
	-- check the rooms around me to see if I can put a room there
		current_room = pick_random_room(map)
		open_locations = check_locations(current_room, "regular", map)
		if #open_locations > 0 then
			door_location = open_locations[math.random(1, #open_locations)]
			current_room = move_room(current_room, door_location)
			rnd_req_room = math.random(1, #required_rooms)
			map.level[current_room[1]][current_room[2]] = required_rooms[rnd_req_room]
			table.remove(required_rooms, rnd_req_room)
		else
			room_loop = room_loop + 1
			if room_loop > 100 then
				create_map(lvl)
			end
		end
	end
	room_loop = 0
	while #extra_rooms > 0 do
		--print("Adding Extra Rooms")
		current_room = pick_random_room(map)
		open_locations = check_locations(current_room, "extra", map)
		if #open_locations > 0 then
			door_location = open_locations[math.random(1, #open_locations)]
			current_room = move_room(current_room, door_location)
			rnd_req_room = math.random(1, #extra_rooms)
			map.level[current_room[1]][current_room[2]] = extra_rooms[rnd_req_room]
			table.remove(extra_rooms, 1)
		else
			room_loop = room_loop + 1
			if room_loop > 100 then
				create_map(lvl)
			end
		end
	end
	room_loop = 0
	-- Add optional_rooms after level 2
	if lvl > 2 then
		-- How many optional rooms should we add?
		if optional_rooms[1] then
			opt_rooms = math.random(#optional_rooms)
			while opt_rooms > 0 do
				--print("Adding An Optional Rooms"..opt_rooms)
				current_room = pick_random_room(map)
				open_locations = check_locations(current_room, "regular", map)
				if #open_locations > 0 then
					door_location = open_locations[math.random(1, #open_locations)]
					current_room = move_room(current_room, door_location)
					rnd_room = math.random(1, #optional_rooms)
					map.level[current_room[1]][current_room[2]] = optional_rooms[rnd_room]
					table.remove(optional_rooms, rnd_room)
					opt_rooms = opt_rooms - 1
				else
					room_loop = room_loop + 1
					if room_loop > 100 then
						print("Making New Map")
						create_map(lvl)
					end
				end
			end
		end
	end
	return map.level
end

function move_room(cr,dir)
	if dir == "N" then
		cr[1] = cr[1] - 1
	end
	if dir == "S" then
		cr[1] = cr[1] + 1
	end
	if dir == "W" then
		cr[2] = cr[2] - 1
	end
	if dir == "E" then
		cr[2] = cr[2] + 1
	end
	return cr
end

function pick_random_room(m)
	local rooms = {}
	for row_num, rowd in ipairs(m.level) do
		for col_num, room in ipairs(rowd) do
			if room == "R" or room == "S" then
				table.insert(rooms, {row_num, col_num})
			end
		end
	end
	local the_choosen_room = math.random(1, #rooms)
	return rooms[the_choosen_room]
end

function check_locations(cr, room_type, map)
	local row = cr[1]
	local column = cr[2]
	local check_rooms = {}
	local open_rooms = {}

	-- check north
	row = row - 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[1] = map.level[row][column]
		table.insert(open_rooms, "N")
	else
		check_rooms[1] = nil
	end
	-- check north west
	column = column - 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[2] = map.level[row][column]
	else
		check_rooms[2] = nil
	end
	-- check west
	row = row + 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[3] = map.level[row][column]
		table.insert(open_rooms, "W")
	else
		check_rooms[3] = nil
	end
	-- check south west
	row = row + 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[4] = map.level[row][column]
	else
		check_rooms[4] = nil
	end
	-- check south
	column = column + 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[5] = map.level[row][column]
		table.insert(open_rooms, "S")
	else
		check_rooms[5] = nil
	end
	-- check south east
	column = column + 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[6] = map.level[row][column]
	else
		check_rooms[6] = nil
	end
	-- check east
	row = row - 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[7] = map.level[row][column]
		table.insert(open_rooms, "E")
	else
		check_rooms[7] = nil
	end
	-- check north east
	row = row - 1
	if map.level[row] and map.level[row][column] ~= nil then
		check_rooms[8] = map.level[row][column]
	else
		check_rooms[8] = nil
	end

	if room_type == "regular" then
		-- if the north room exists and it is not empty and the north west room exists and it is not empty then
		if check_rooms[1] ~= nil and check_rooms[1] ~= "." and check_rooms[2] ~= nil and check_rooms[2] ~= "." then
			-- if the west room is empty then take it out of the available rooms
			if check_rooms[3] == "." then
				index = whereinTable(open_rooms, "W")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[1] ~= nil and check_rooms[1] ~= "." and check_rooms[8] ~= nil and check_rooms[8] ~= "." then
			if check_rooms[7] == "." then
				index = whereinTable(open_rooms, "E")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[5] ~= nil and check_rooms[5] ~= "." and check_rooms[6] ~= nil and check_rooms[6] ~= "." then
			if check_rooms[7] == "." then
				index = whereinTable(open_rooms, "E")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end

		if check_rooms[5] ~= nil and check_rooms[5] ~= "." and check_rooms[4] ~= nil and check_rooms[4] ~= "." then
			if check_rooms[3] == "." then
				index = whereinTable(open_rooms, "W")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[7] ~= nil and check_rooms[7] ~= "." and check_rooms[8] ~= nil and check_rooms[8] ~= "." then
			if check_rooms[1] == "." then
				index = whereinTable(open_rooms, "N")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[3] ~= nil and check_rooms[3] ~= "." and check_rooms[2] ~= nil and check_rooms[2] ~= "." then
			if check_rooms[1] == "." then
				index = whereinTable(open_rooms, "N")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[3] ~= nil and check_rooms[3] ~= "." and check_rooms[4] ~= nil and check_rooms[4] ~= "." then
			if check_rooms[5] == "." then
				index = whereinTable(open_rooms, "S")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
		
		if check_rooms[7] ~= nil and check_rooms[7] ~= "." and check_rooms[6] ~= nil and check_rooms[6] ~= "." then
			if check_rooms[5] == "." then
				index = whereinTable(open_rooms, "S")
				if index ~= false then
					table.remove(open_rooms, index)
				end
			end
		end
	end

		-- Tried making this a loop, didn't work kept overwriting start room
	if check_rooms[1] ~= "." then
		index = whereinTable(open_rooms, "N")
		if index ~= false then
			table.remove(open_rooms, index)
		end
	end
	if check_rooms[3] ~= "." then
		index = whereinTable(open_rooms, "W")
		if index ~= false then
			table.remove(open_rooms, index)
		end
	end
	if check_rooms[5] ~= "." then
		index = whereinTable(open_rooms, "S")
		if index ~= false then
			table.remove(open_rooms, index)
		end
	end
	if check_rooms[7] ~= "." then
		index = whereinTable(open_rooms, "E")
		if index ~= false then
			table.remove(open_rooms, index)
		end
	end
	return open_rooms
end

function whereinTable(tbl, item)
	for index, value in ipairs(tbl) do
		if value == item then 
			return index
		end
	end
	return false
end