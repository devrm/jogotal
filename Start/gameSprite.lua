GameSprite = {
	sprite,
	spriteSheet,
	velocidade = 3,
	estadoSprite
}
function GameSprite:setSpriteSheet(imageName, options)
	self.spriteSheet = graphics.newImageSheet(imageName, options)
end
function GameSprite:createSprite(sequenceData)	
	self.sprite = display.newSprite(self.spriteSheet, sequenceData)	
end
function GameSprite:setEstado(estado)
	self.estadoSprite = estado
end
function GameSprite:new(o)
	o = o or {} 
	setmetatable(o, self)
	self.__index = self
	return o
end
function GameSprite:mover(eixoX, eixoY, isDireita)
	self.estadoSprite = EstadoCorrendo:new()
	self:acao()
	local movimento = eixoX
	if isDireita then
		movimento = self.velocidade
		self.sprite.xScale = 1
	else
		movimento = -self.velocidade
		self.sprite.xScale = -1
	end		
	return movimento
end
function GameSprite:adicionarColisao(nome, funcaoColisao)
	self.sprite.collision = funcaoColisao
	self.sprite:addEventListener(nome, self.sprite)
end
function GameSprite:acao()	
	self.estadoSprite:executarAcao(self)
end

function GameSprite:test()
	print("teste classe pai")
end

-- Interface criada para todos os estados
EstadoSprite = {}
function EstadoSprite:new(o)
	o = o or {} 
	setmetatable(o, self)
	self.__index = self
	return o
end
function EstadoSprite:pular(gameSprite)
	print("pulando")
end
function EstadoSprite:correr(gameSprite)
	print("correndo")
end
function EstadoSprite:parar(gameSprite)
	print("parado")
end
function EstadoSprite:executarAcao(gameSprite)
	print("executando acao generica")
end

EstadoParado = {}
function EstadoParado:new(o)
	o = o or {} 
	setmetatable(o, self)
	self.__index = self
	return o
end
function EstadoParado:executarAcao(gameSprite)
	gameSprite.sprite:pause()
	gameSprite.sprite:setFrame(1)
	print("acao parado")
end
function EstadoParado:correr(gameSprite)
	gameSprite.estadoSprite = EstadoCorrendo:new()	
end
function EstadoParado:pular(gameSprite)
	gameSprite.estadoSprite = EstadoPulando:new()
end

EstadoCorrendo = {}
function EstadoCorrendo:new(o)
	o = o or {} 
	setmetatable(o, self)
	self.__index = self
	return o	
end
function EstadoCorrendo:executarAcao(gameSprite)	
	print("correndo")
end
function EstadoCorrendo:parar(gameSprite)
	gameSprite.estadoSprite = EstadoParado:new()	
end


EstadoPulando = {}
function EstadoPulando:new(o)
	o = o or {} 
	setmetatable(o, self)
	self.__index = self
	return o
end
function EstadoPulando:correr(gameSprite)
	gameSprite.estadoSprite = EstadoCorrendo:new()	
end
function EstadoPulando:parar(gameSprite)
	gameSprite.estadoSprite = EstadoParado:new()	
end
function EstadoPulando:executarAcao(gameSprite)	
	gameSprite.sprite:setSequence("pulando")
	gameSprite.sprite:play()
	gameSprite.sprite:setLinearVelocity( 0, -175 )
end












