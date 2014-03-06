require "estados.Estado"

local EstadoAtivo = {}
local EstadoAtivo_mt = { __index = EstadoAtivo }
function EstadoAtivo.new(owner)	
	local novoEstadoAtivo = {}
	novoEstadoAtivo.owner = owner
	setmetatable(novoEstadoAtivo, EstadoAtivo_mt)
	novoEstadoAtivo.owner = owner	
	setmetatable(EstadoAtivo, { __index, Estado})	
	return novoEstadoAtivo
end
function EstadoAtivo:onEnterState(event)
end

function EstadoAtivo:onExitState(event)
end

function EstadoAtivo:executeAction(event, deltaTime)	
	self.owner:setSequence("parado")
	self.owner:play()
	self.owner:setFrame(1)
end	
return EstadoAtivo