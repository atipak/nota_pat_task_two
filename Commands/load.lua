function getInfo()
	return {
		onNoUnits = SUCCESS,
		parameterDefs = {
      { 
				name = "transporterId",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "Sensors.nota_pat_task_two.TransporterId()"
			},
      { 
				name = "unitsToLoad",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = "{}"
			}
		}
	}
end

local alreadyLaunch = false
local threshold = 25

function Run(self, unitIds, parameter) 
	units = unitIds
	unitsSize = #units
  
  if parameter.transporterId == nil then 
    return FAILURE
  end
  
  -- order already launched
  if alreadyLaunch then 
    if CheckLoadedUnits(units, parameter.transporterId) then 
      return RUNNING
    else 
      return SUCCESS 
    end 
  end
    
  for index = 1, #units do
    local unitId = units[index] 
    if (unitId ~= parameter.transporterId) then
      Spring.GiveOrderToUnit(parameter.transporterId, CMD.INSERT, {-1, CMD.LOAD_UNITS, CMD.OPT_SHIFT, unitId}, {"alt"})
      --Spring.GiveOrderToUnit(parameter.transporterId, CMD.LOAD_UNITS, {unitId}, {})
    end
  end
  alreadyLaunch = true
  return RUNNING
end

-- function for sending commands
function CheckLoadedUnits(units, tid)
  local isRunning = false
  for index = 1, #units do
    unitId = units[index]
    if unitId ~= tid then
      local transport = Spring.GetUnitTransporter(unitId)
      if transport == nil then
        if #Spring.GetUnitCommands(tid) == 0 then 
          Spring.GiveOrderToUnit(tid, CMD.INSERT, {-1, CMD.LOAD_UNITS, CMD.OPT_SHIFT, unitId}, {"alt"})
        end
        isRunning = true
        break 
      end
    end          
  end 
  return isRunning
end
  