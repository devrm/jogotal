require "estados.MovendoState"

CorrendoDireitaState = {}
function CorrendoDireitaState:new()

	local estado = MovendoState:new("correrDireita")
	estado.superOnEnterState = estado.onEnterState
	
	function estado:onEnterState(event)
		self:superOnEnterState(event)
		--self.entity:setDirection("right")
		--self.entity:showSprite("move")
		print ("faz algo ao entrar no estado ativo")
	end

	return estado	
end
return CorrendoDireitaState