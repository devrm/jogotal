require "com.jessewarden.statemachine.BaseState"

PulandoState = {}
function CorrerDireitaState:new()

	local estado = PulandoState:new("pulando")
	estado.superOnEnterState = estado.onEnterState
	
	function estado:onEnterState(event)
		self:superOnEnterState(event)
		--self.entity:setDirection("right")
		--self.entity:showSprite("move")
		print ("faz algo ao entrar no estado pulando")
	end

	function estado:onExitState(event)
		print ("faz algo ao sair do estado de pulando")
	end
	
	function estado:onAttackAnimationCompleted(event)
		print ("completou animacao de pulando")
	end	
	
	return estado	
end
return PulandoState