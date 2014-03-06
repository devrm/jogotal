local EstadoAtivo = require ( "estados.EstadoAtivo" )
require "estados.MovendoState"
require "estados.EstadoPulando"
require "estados.PulandoParabolaState"

StateMachine = {}
function StateMachine.new(jogador)
	local stateMachine = {}
	stateMachine.owner = jogador
	stateMachine.currentState = EstadoAtivo:new(jogador)
	stateMachine.previousState = nil
	stateMachine.globalState = nil
	stateMachine.deltaTime = nil
	
	function stateMachine:changeState(state)
		
		self.previousState = self.currentState
		
		self.currentState:onExitState()
		
		self.currentState  = state		
		
		self.currentState:onEnterState()
		
	end
	
	function stateMachine:changeToPreviousState()
		self:changeState(self.previousState)
	end
	
	function stateMachine:getCurrentState()
		return self.currentState
	end
	
	function stateMachine:move(event, isRight)		
		self.owner:setSequence("correndo")
		self.owner:play()		
		local moveState = MovendoState:new(self.owner, isRight, self.deltaTime)
		self:changeState(moveState)
	end
	
	function stateMachine:jump()
		local jumpState = EstadoPulando:new(self.owner, self.deltaTime)		
		self:changeState(jumpState)
	end	
	
	function stateMachine:attack()		
		self.owner:setSequence("attack")
		self.owner:play()
		local attackState = EstadoAtaque:new(self.owner)
		self:changeState(attackState)		
	end
	
	
	function stateMachine:update(deltaTime)		
		if (self.globalState) then
			self.globalState:executeAction(event, deltaTime)
		end
		
		if (self.currentState) then
			self.currentState:executeAction(event, deltaTime)
		end
	end
	
	function stateMachine:movingJump(event, isRight)		
		local jump = PulandoParabolaState:new(self.owner, isRight, self.deltaTime)
		self:changeState(jump)
	end
	
	function stateMachine:active()
		local activeState = EstadoAtivo.new(self.owner)
		self:changeState(activeState)
	end
	
	function stateMachine:setDeltaTime(deltaTime)
		stateMachine.deltaTime = deltaTime
	end	

	local function hideObject(object) 
		object.alpha = 0.3;
		transition.to(object, {alpha=1, time=1500})			
		--object.x = object.x + 10 * (object.xScale*-1) EMPURRAR PARA TRÁ		
	end
	
	
	-- implementa o evento acionado quando existir colisao
	local colisao = function (self, event)
		if ( event.phase == "began" ) then
			if event.other.name == "chaoFisico" then
				if stateMachine.isHolding then			
					self.fsm:move(event, isRight)
				else
					self.fsm:active()			
				end				
			else
				timer.performWithDelay(1, hideObject(self))
			end
			
		end
	end
	

	
	local function onPostCollision( self, event )
       self.bodyType = "kinematic"
	   self.isSensor = true
	end
 
	
	-- registra o evento de colisao
	stateMachine.owner:addEventListener("collision", stateMachine.owner)
	stateMachine.owner:addEventListener( "postCollision", onPostCollision )
	stateMachine.owner.collision = colisao
	
	
	return stateMachine
end
return StateMachine
