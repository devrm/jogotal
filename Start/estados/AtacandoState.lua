require "com.jessewarden.statemachine.BaseState"

AtacandoState = {}
function AtacandoState:new()

	local estado = BaseState:new("atacando")
	
	function estado:onEnterState(event)
		self:superOnEnterState(event)
		--self.entity:setDirection("right")
		--self.entity:showSprite("move")
		print ("faz algo ao entrar no estado ataque")
	end

	function estado:onExitState(event)
		print ("faz algo ao sair do estado de ataque")
	end
	
	function estado:onAttackAnimationCompleted(event)
		print ("completou animacao de ataque")
	end
	
	
	return estado	
end
return AtacandoState