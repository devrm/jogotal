require "com.jessewarden.statemachine.BaseState"

MovendoState = {}

function MovendoState:new(nomeEstado)
	
	local estado = BaseState:new(nomeEstado)
	estado.jogador = nil
	
	
	function estado:onEnterState(event)
		print ("entrando no estado movendo")
		
		--Registra eventos
		
	end
	
	function estado:onExitState(event)
		print("saindo do estado")
		
		-- Remove listener eventos
	end
	
	function estado:onMoveEnded(event)
		self.stateMachine:changeStateToAtNextTick("ativo")
	end
	
	function estado:onAttackStarted(event)
		self.stateMachine:changeStateToAtNextTick("atacando")
	end
	
	function estado:onJumpStarted(event)
		self.stateMachine:changeStateToAtNextTick("pulando")
	end
	
	return estado
end
return MovendoState