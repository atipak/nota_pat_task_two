local sensorInfo = {
	name = "HillsPositions",
	desc = "Returns id of transporter",
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
local tranposterID = nil


-- @description return current wind statistics
return function()
  if tranposterID ~= nil then 
    return tranposterID
  end
  if #units == 0 then 
    return nil
  end
  for i = 1, #units do
    local unitId = units[i]
    local unitDefID = Spring.GetUnitDefID(unitId)
    if UnitDefs[unitDefID].name == "armthovr" then
       tranposterID = unitId 
       return unitId
    end          
  end 
  return nil
end