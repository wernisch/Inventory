--[[
    ---------------------------------------------------------
       A simple lua inventory for LÖVE/ROBLOX by @BloxyHDD
    ---------------------------------------------------------

    example usage:
    InventoryModule = require(path_to_this)
    local inventory = InventoryModule.initInventory(player)

    inventory:addItem("ItemName", "ItemDescription", amount)
    ↓↓↓
    inventory:addItem("Sword", "A Sharp Sword", 1)

    local items = inventory:displayInventory() --returns the inventory table
    (
        player = {
            {} = {
                Name = "Sword",
                Description = "A Sharp Sword",
                Amount = 1,
            }
        }
    )
]] 

local inventories = {}

local function createInventory()
    return {
        items = {},
        addItem = function(self, itemName, itemDescription, amount)
            local existingItem = self:findItem(itemName)
            if existingItem then
                existingItem.Amount = existingItem.Amount + (amount or 1)
            else
                table.insert(self.items, {
                    Name = itemName,
                    Description = itemDescription,
                    Amount = amount or 1
                })
            end
        end,
        removeItem = function(self, itemName, Amount)
            for i, item in ipairs(self.items) do
                if item.Name == itemName then
                    if Amount and Amount < item.Amount then
                        item.Amount = item.Amount - Amount
                    else
                        table.remove(self.items, i)
                    end
                    return true
                end
            end
            return false
        end,
        findItem = function(self, itemName)
            for _, item in ipairs(self.items) do
                if item.Name == itemName then
                    return item
                end
            end
            return nil
        end,
        displayInventory = function(self)
            local inventoryTable = {}
            for _, item in ipairs(self.items) do
                table.insert(inventoryTable, {
                    Name = item.Name,
                    Description = item.Description,
                    Amount = item.Amount
                })
            end
            return inventoryTable
        end
    }
end

local function initInventory(player)
    inventories[player] = inventories[player] or createInventory()
    return inventories[player]
end

return {
    initInventory = initInventory,
    inventories = inventories
}
