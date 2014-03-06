require "estados.Estado"


EstadoPulando = {}
function EstadoPulando:new(owner)

	local estado = Estado:new()
	estado.deltaTime = deltaTime
	local owner = owner
	local isExecute = true
	
	function estado:onEnterState(event)	
		
	end

	function estado:onExitState(event)
		isExecute = false
	end
	
	function estado:executeAction(event, deltaTime)
		if isExecute then
			owner:setLinearVelocity( 0, -175*deltaTime )				
			owner:setSequence("pulando")
			owner:play()
			isExecute = false
		end
	end	
	
	function isJumping()
		return isExecute
	end
	
	return estado	
end
return EstadoPulando