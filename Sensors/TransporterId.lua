local sensorInfo = {
	name = "TransporterID",
	desc = "Returns id of transporter. It can return nil",
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
local transporterID = nil


-- @description return current wind statistics
return function()
  -- transporterID was already found  and is not dead
  if transporterID ~= nil then 
    if not Spring.GetUnitIsDead(transporterID) then 
      return transporterID
    else 
      transporterID = nil
    end
  end
  -- there are no units
  if #units == 0 then 
    return nil
  end
  -- searching over all units, if bear is found, its id is stored and returned
  for i = 1, #units do
    local unitId = units[i]
    local unitDefID = Spring.GetUnitDefID(unitId)
    if UnitDefs[unitDefID].name == "armthovr" then
       transporterID = unitId 
       return unitId
    end          
  end 
  return nil
end