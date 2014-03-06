require "estados.Estado"

EstadoAtivo = {}
EstadoAtivo_mt = { __index = EstadoAtivo }
function EstadoAtivo:new(owner)
	local novoEstadoAtivo = {}	
	novoEstadoAtivo.owner = owner
	setmetatable(novoEstadoAtivo, EstadoAtivo_mt)	
	setmetatable(EstadoAtivo, { __index, Estado})
	return novoEstadoAtivo
end
function EstadoAtivo:onEnterState(event)

	--print ("faz algo ao entrar no estado ativo")
end

function EstadoAtivo:onExitState(event)
	--print ("faz algo ao sair do estado de ativo")
end

function EstadoAtivo:executeAction(event, deltaTime)		
	print("passou AQUI")
	self.owner:setSequence("parado")			
	self.owner:play()
	self.owner:setFrame(1)
end	
	