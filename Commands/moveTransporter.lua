function getInfo()
	return {
		onNoUnits = SUCCESS,
		parameterDefs = {
			{ 
				name = "targetPosition",
				variableType = "expression",
				componentType = "editBox",
				defaultValue = ""
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
local threshold = 20

function Run(self, unitIds, parameter) 
	units = unitIds
	unitsSize = #unitIds
  
  if parameter.transporterId == nil then 
    return FAILURE
  end
  local target = parameter.targetPosition + Vec3(20,0,20) 
  
  -- order already launched
  if alreadyLaunch then 
    if CheckTransporterPosition(parameter.transporterId, target) then 
      return RUNNING
    else 
      return SUCCESS 
    end 
  end       
  Spring.GiveOrderToUnit(parameter.transporterId, CMD.MOVE, target:AsSpringVector(), {})
  alreadyLaunch = true
  return RUNNING
end

-- function for sending commands
function CheckTransporterPosition(tid, target)
  local isRunning = false
  local lx, ly, lz = Spring.GetUnitPosition(tid)
  if math.abs(lx - target.x) > threshold or math.abs(lz - target.z) > threshold then 
      isRunning = true  
  end
  return isRunning
end
  