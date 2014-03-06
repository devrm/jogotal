require ("Minion")

EnemyManager = {}

function EnemyManager:new(waveSize, groupEnemy)

	local enemyManager = {}
	enemyManager.enemiesCount = waveSize
	enemyManager.list = {}

	function enemyManager:addEnemy(enemy)		
		if #enemyManager.list <= waveSize then
			table.insert(self.list, enemy)			
		end		
	end


	function enemyManager:action(deltaTime)		
		for i=1, #enemyManager.list do			
			enemyManager.list[i].fsm:update(deltaTime)
		end		
	end	
	
	function enemyManager:getWaveSize()
		return enemyManager.enemiesCount
	end
	
	function enemyManager:getEnemyList()
		return enemyManager.list
	end
	
	
	return enemyManager
end
return EnemyManager