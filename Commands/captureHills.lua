function getInfo()
	return {
		onNoUnits = SUCCESS,
		parameterDefs = {
			{ 
				name = "hillsPositions",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "Sensors.nota_pat_task_two.HillsPosition()"
			},
      { 
				name = "transporterId",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "Sensors.nota_pat_task_two.TransporterId()"
			}
		}
	}
end

local alreadyLaunch = false
local unitsGoals = {}
local threshold = 3

function Run(self, unitIds, parameter) 
	units = unitIds
	unitsSize = #unitIds
  hills = parameter.hillsPositions 
  trans = parameter.transporterId
  hillsSize = table.getn(hills)
  -- order already launched
  if alreadyLaunch then 
    if CheckSoldiersPositions() then 
      return RUNNING
    else 
      return SUCCESS 
    end 
  end
  
  -- no hills
  if hills == nil or hillsSize == 0 then 
    return SUCCESS
  end
  
  -- no transporter
  if trans == nil then 
    return FAILURE
  end
  
  unitsSize = unitsSize - 1
  
  -- more hills than soldiers
  if hillsSize > unitsSize then 
    return FAILURE
  end
  hillsIndex = 1
    
  for index = 1, #units do
    local unitId = units[index] 
    if (unitId ~= trans) and (hillsIndex <= hillsSize) then
      unitsGoals[unitId] = hills[hillsIndex]  
      Spring.GiveOrderToUnit(unitId, CMD.MOVE, hills[hillsIndex]:AsSpringVector(), {})
      hillsIndex = hillsIndex + 1
    end
  end
  alreadyLaunch = true
  return RUNNING
end

-- function for sending commands
function CheckSoldiersPositions()
  local isRunning = false
  for unitId,hillsPosition in pairs(unitsGoals) do
    local lx, ly, lz = Spring.GetUnitPosition(unitId)
    if math.abs(lx - hillsPosition.x) > threshold or math.abs(ly - hillsPosition.y) > threshold or math.abs(lz - hillsPosition.z) > threshold then 
      isRunning = true  
    end      
  end 
  return isRunning
end
  