Estado = {}
Estado_mt = { __index = Estado }
function Estado.new(name, owner)
	local estado = {}
	estado.name = name
	estado.owner = owner	
	setmetatable(estado, Estado_mt)
	return estado
end
function Estado:executeAction()
	print ("executando acao do estado")
end

function Estado:onEnterState(event)
	print ("faz algo ao entrar no estado ativo")
end

function Estado:onExitState(event)
	print ("faz algo ao sair do estado ativo")
end