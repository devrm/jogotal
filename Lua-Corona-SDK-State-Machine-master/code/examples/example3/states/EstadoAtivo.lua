require "Estado"

EstadoAtivo = {}

function EstadoAtivo:new()

	local estado = Estado:new()


	function EstadoAtivo:handle()
	
		print ("estado ativo")

	end
	return estado
	
	
end
return EstadoAtivo