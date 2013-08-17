require "com.jessewarden.statemachine.BaseState"

AtivoState = {}
function AtivoState:new()

	local estado = BaseState:new("ativo")
	estado.recharge = nil
	estado.startRestTime = nil
	estado.elapsedRestTime = nil
	
	
	function estado:onEnterState(event)
		print ("faz algo ao entrar no estado ativo")
	end
	
	function estado:onExitState(event)
		print ("faz algo ao sair do estado ativo")
	end
	
	
	function estado:onCorrendoDireitaStateStarted(event)
		print ("CorrerDireita")
		self.stateMachine:changeStateToAtNextTick("correrDireita")
	end

	function estado:onPulandoStateStarted(event)
		print ("pulando")
		self.stateMachine:changeStateToAtNextTick("pulando")
	end
	
	
	--function estado:onCorrerEsquerdaStateStarted(event)
	--	print ("CorrerEsquerda")
	--	self.stateMachine:changeStateToAtNextTick("correrEsquerda")
	--end

	return estado	
end
return AtivoState