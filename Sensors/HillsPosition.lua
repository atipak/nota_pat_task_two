local sensorInfo = {
	name = "HillsPositions",
	desc = "Returns positions of right bottom corners of hills on the map. Homework specific",
	author = "Patik",
	date = "2018-05-11",
	license = "notAlicense",
}

local EVAL_PERIOD_DEFAULT = 0 -- acutal, no caching

function getInfo()
	return {
		period = EVAL_PERIOD_DEFAULT 
	}
end

-- variables
local minConstant = -500000
local maxConstant = 500000
local minimum = maxConstant
local maximum = minConstant
local iterationShift = 40
local corners = {}


-- @description return current wind statistics
return function()
  -- help variables
  local mapHeight = Game.mapSizeZ
  local mapWidth = Game.mapSizeX
  -- minimum hasn't been changed yet -> either first iteration or no units for orders
  if minimum == minConstant then
    for unit_id = 1, #units do 
      if Spring.ValidUnitID(unit_id) then 
        local pos = Spring.GetUnitPosition(unit_id)
        break
      end
    end
  end
  -- no units
  if minimum == minConstant then 
    return corners
  end  
  -- 4 corners - hills were already found 
  if table.getn(corners) > 0 then 
    return corners
  end
  local i = 1
  -- grid searching
  for z = 1, mapHeight, iterationShift do 
    for x = 1, mapWidth, iterationShift do 
      local y = Spring.GetGroundHeight(x, z)
      -- variables for north, east, west, south directions -> cross searching of corners
      local px, mx, pz, mz = mapWidth, 1, mapHeight, 1
      -- east point
      if x + iterationShift < mapWidth then 
         px = x + iterationShift
      end 
      -- south point
      if z - iterationShift > 1 then 
         mz = z - iterationShift
      end 
      -- west point
      if x - iterationShift > 1 then 
         mx = x - iterationShift
      end 
      -- nord point
      if z + iterationShift < mapHeight then 
         pz = z + iterationShift
      end 
      -- cross searching = is it a right bottom corner? 
      if (y > Spring.GetGroundHeight(px, z)) and (y > Spring.GetGroundHeight(x, mz)) and (y == Spring.GetGroundHeight(mx, z)) and (y == Spring.GetGroundHeight(x, pz)) then 
        corners[i] = Vec3(x, y, z) + Vec3(-iterationShift, 0, iterationShift)
        i = i + 1
      end
    end 
  end
  return corners   
end