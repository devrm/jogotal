ButtonsController = {}

function ButtonsController:new()

	local buttons = display.newGroup()
	buttons.stateMachine = nil

	function buttons:init()
		local defaultCallback = function(e)self:onButtonClick(e)end

		local buttonWidth = 80
		local buttonHeight = 40

		local walkLeftButton = Button:new("Left", function(e)self:onMoveLeft(e)end, 4, 0, buttonWidth, buttonHeight)
		local walkRightButton = Button:new("Right", function(e)self:onMoveRight(e)end, walkLeftButton.x + walkLeftButton.width + 4, walkLeftButton.y, buttonWidth, buttonHeight)
		local defendButton = Button:new("Defend", function(e)self:onDefend(e)end, walkRightButton.x + walkRightButton.width + 4, walkRightButton.y, buttonWidth, buttonHeight)
		local attackButton = Button:new("Attack", function(e)self:onAssault(e)end, defendButton.x + defendButton.width + 4, defendButton.y, buttonWidth, buttonHeight)
		local scoutButton = Button:new("Scout", function(e)self:onScout(e)end, 4, walkLeftButton.y - walkLeftButton.height - 4, buttonWidth, buttonHeight)
		local rollLeftButton = Button:new("Left", function(e)self:onRollLeft(e)end, walkLeftButton.x, walkLeftButton.y, buttonWidth, buttonHeight)
		local rollRightButton = Button:new("Right", function(e)self:onRollRight(e)end, walkRightButton.x, walkRightButton.y, buttonWidth, buttonHeight)
		local sightButton = Button:new("Sight", function(e)self:onSight(e)end, attackButton.x, attackButton.y - buttonHeight, buttonWidth, buttonHeight)
		local sniperButton = Button:new("Sniper", function(e)self:onSniper(e)end, sightButton.x + buttonWidth + 4, sightButton.y, buttonWidth, buttonHeight)
		local artilleryButton = Button:new("Artillery", function(e)self:onArtillery(e)end, sniperButton.x + buttonWidth + 4, sniperButton.y, buttonWidth, buttonHeight)
		
		self:insert(walkLeftButton)
		self:insert(walkRightButton)
		self:insert(defendButton)
		self:insert(attackButton)
		self:insert(scoutButton)
		self:insert(rollLeftButton)
		self:insert(rollRightButton)
		self:insert(sightButton)
		self:insert(sniperButton)
		self:insert(artilleryButton)

		self.walkLeftButton = walkLeftButton
		self.walkRightButton = walkRightButton
		self.defendButton = defendButton
		self.attackButton = attackButton
		self.scoutButton = scoutButton
		self.rollLeftButton = rollLeftButton
		self.rollRightButton = rollRightButton
		self.sightButton = sightButton
		self.sniperButton = sniperButton
		self.artilleryButton = artilleryButton
	end

	function buttons:setStateMachine(fsm)
		if self.stateMachine then
			self.stateMachine:removeEventListener("onStateMachineStateChanged", self)
		end
		self.stateMachine = fsm
		if fsm then
			fsm:addEventListener("onStateMachineStateChanged", self)
		end
		self:onStateMachineStateChanged()
	end

	function buttons:hideAllButtons()
		self.walkLeftButton.isVisible = false
		self.walkRightButton.isVisible = false
		self.defendButton.isVisible = false
		self.attackButton.isVisible = false
		self.scoutButton.isVisible = false
		self.rollLeftButton.isVisible = false
		self.rollRightButton.isVisible = false
		self.sightButton.isVisible = false
		self.sniperButton.isVisible = false
		self.artilleryButton.isVisible = false
	end

	function buttons:onStateMachineStateChanged(event)
		local state = self.stateMachine.state
		print("state: ", state)
		self:hideAllButtons()
		if state == "scout" or state == "scoutLeft" or state == "scoutRight" then
			self.walkLeftButton.isVisible = true
			self.walkRightButton.isVisible = true
			self.defendButton.isVisible = true
			self.attackButton.isVisible = true
		elseif state == "defend" then
			self.defendButton.isVisible = true
		elseif state == "assault" then
			self.rollLeftButton.isVisible = true
			self.rollRightButton.isVisible = true
			self.defendButton.isVisible = true
			self.scoutButton.isVisible = true
			self.sightButton.isVisible = true
			self.sniperButton.isVisible = true
			self.artilleryButton.isVisible = true
		elseif state == "assaultLeft" or state == "assaultRight" then
			self.rollLeftButton.isVisible = true
			self.rollRightButton.isVisible = true
			self.scoutButton.isVisible = true
		elseif state == "sight" or state == "sniper" or state == "artillery" then
			self.attackButton.isVisible = true
		end


	end

	function buttons:onMoveLeft(event)
		if event.phase == "began" then
			self.stateMachine:changeState("scoutLeft") 
		elseif event.phase == "ended" or event.phase == "cancelled" then
			self.stateMachine:changeState("scout") 
		end
	end

	function buttons:onMoveRight(event)
		if event.phase == "began" then
			self.stateMachine:changeState("scoutRight") 
		elseif event.phase == "ended" or event.phase == "cancelled" then
			self.stateMachine:changeState("scout") 
		end
	end

	function buttons:onDefend(event)
		if event.phase == "began" then
			self.stateMachine:changeState("defend")
		elseif event.phase == "ended" then
			self.stateMachine:changeState(self.stateMachine.previousState)
		end
	end

	function buttons:onAssault(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("assault")
		end
	end

	function buttons:onScout(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("scout")
		end
	end

	function buttons:onRollLeft(event)
		if event.phase == "began" then
			self.stateMachine:changeState("assaultLeft") 
		elseif event.phase == "ended" or event.phase == "cancelled" then
			self.stateMachine:changeState("assault") 
		end
	end

	function buttons:onRollRight(event)
		if event.phase == "began" then
			self.stateMachine:changeState("assaultRight") 
		elseif event.phase == "ended" or event.phase == "cancelled" then
			self.stateMachine:changeState("assault") 
		end
	end

	function buttons:onSight(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("sight")
		end
	end

	function buttons:onSniper(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("sniper")
		end
	end

	function buttons:onArtillery(event)
		if event.phase == "ended" then
			self.stateMachine:changeState("artillery")
		end
	end


	return buttons
end

return ButtonsController