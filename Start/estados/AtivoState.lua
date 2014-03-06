Estado = {}
function Estado:new()

	local estado = {}
	estado.recharge = nil
	estado.startRestTime = nil
	estado.elapsedRestTime = nil
	
	function estado:executeAction()
		print ("executando acao do estado")
	end
	
	function estado:onEnterState(event)
		print ("faz algo ao entrar no estado ativo")
	end
	
	function estado:onExitState(event)
		print ("faz algo ao sair do estado ativo")
	end

	return estado	
end
return Estado