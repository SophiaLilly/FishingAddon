local _G = _G
local fishing = CreateFrame('Frame')

fishing:RegisterEvent('LOOT_OPENED')
fishing:RegisterEvent('ADDON_LOADED')
fishing:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
fishing:RegisterEvent('PLAYER_ENTERING_WORLD')
fishing:RegisterEvent('CINEMATIC_STOP')

print('Events Registered')

fishing:SetScript('OnEvent', function(self, event, ...)

	local args = { ... }
	print('Event:', event)
	
	-- ADDON_LOADED event
	if event == 'ADDON_LOADED' and args[1] == 'Fishing_Test' then
	
		if FishingTable == nil then -- If SV FishingTable doesn't exist

			FishingTable = {} -- Make a new one
		
		end

		if NewCharacter == nil then -- If this is the first time loading this character
			print('reeeeeeeeee')
			
			
		
		end
		print('Amount:', table.getn(FishingTable))
	
	end
	
	-- CINEMATIC_STOP event
	if event == 'CINEMATIC_STOP' and NewCharacter == nil then
	
		NewCharacter = true
		for i = 1, 15 do
		
			local itemId = GetInventoryItemID('player', i)
			if itemId ~= nil then
				
				local itemName, _, _, _, _, itemType, itemSubtype, _, _, _, _ = GetItemInfo(itemId)
				print(itemName)
				table.insert(FishingTable, itemName)
				
			end
				
		end
	
	end
	
	-- LOOT_OPENED event
	if event == 'LOOT_OPENED' and IsFishingLoot() then
	
		for i = 1, GetNumLootItems() do
		
			local add = true -- Assume this item will be added to the table

			_, lootName, _, _, _, _, _, _ = GetLootSlotInfo(i)
			--print(lootName)
			
			for j = 1, table.getn(FishingTable) do
			
				if FishingTable[j] == lootName then -- If looted item was found to exist in the table
				
					add = false -- Stop the item from being added to the table
				
				end
			
			end
			
			if add == true then -- If looted item was not found to exist in the table
			
				table.insert(FishingTable, lootName)

			end

		end
	
	end
	
	-- PLAYER_EQUIPMENT_CHANGED event
	if event == 'PLAYER_EQUIPMENT_CHANGED' then
		
		for i = 1, 15 do
		
			local itemId = GetInventoryItemID('player', i)
			if itemId ~= nil then
			
				local fail = true -- Assume the new item equipped will fail the challenge
			
				local itemName, _, _, _, _, itemType, itemSubtype, _, _, _, _ = GetItemInfo(itemId)
				--print(itemName)
				
				for j = 1, table.getn(FishingTable) do
				
					if FishingTable[j] == itemName then -- If new item equipped was fished up
					
						fail = false -- Won't fail the challenge
					
					end
				
				end
				
				if fail == true then
					
					print('Failed Challenge')
					
				end
			
			end
		
		end
		
	end

end)
