require ("estados.Estado")

MovendoState = {}
function MovendoState:new(owner, isRight)
	
	local estado = Estado:new()
	local owner = owner
	estado.deltaTime = deltaTime
	estado.name = "MovendoState"
	function estado:onEnterState(event)
		--print ("entrando no estado movendo")
	end
	
	function estado:onExitState(event)
		--print("saindo do estado movendo")
	end
	
	function estado:executeAction(event, deltaTime)		
		local movimento = owner.x		
		if isRight then
			movimento = owner.velocidade
			owner.xScale = 1
		else
			movimento = -owner.velocidade
			owner.xScale = -1
		end		
		owner.x = owner.x + (movimento*deltaTime)
	end
	
	return estado
end

return MovendoState