require "estados.Estado"

EstadoAtaque = {}
function EstadoAtaque:new(owner)

	local estado = Estado:new(name)
	
	function estado:onEnterState(event)
	
		--print ("faz algo ao entrar no estado ativo")
	end

	function estado:onExitState(event)
		--print ("faz algo ao sair do estado de ativo")
	end
	
	function estado:executeAction(event)		
		owner:setSequence("parado")			
		owner:play()
		owner:setFrame(1)
	end	
	return estado	
end
return EstadoAtaque