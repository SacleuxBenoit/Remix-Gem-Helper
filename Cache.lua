---@class RemixGemHelperPrivate
local Private = select(2, ...)

---@class CacheItemInfo
---@field name string
---@field link string
---@field icon number
---@field type number
---@field subType number

local cache = {
    itemInfo = {}
}
Private.Cache = cache


---@param itemID number
---@param loadedCallback fun(itemID:integer)|?
function cache:CacheItemInfo(itemID, loadedCallback)
    local item = Item:CreateFromItemID(itemID)
    item:ContinueOnItemLoad(function()
        local itemInfo = { C_Item.GetItemInfo(item:GetItemLink()) }
        self.itemInfo[itemID] = {
            name = itemInfo[1],
            link = itemInfo[2],
            icon = itemInfo[10],
            type = itemInfo[12],
            subType = itemInfo[13],
        }
        if loadedCallback and type(loadedCallback) == "function" then
            loadedCallback(self.itemInfo[itemID])
        end
    end)
end

---@param itemID number
---@param loadedCallback fun(itemID:integer)|?
---@return CacheItemInfo
function cache:GetItemInfo(itemID, loadedCallback)
    local itemInfo = self.itemInfo[itemID]
    if not itemInfo then
        self:CacheItemInfo(itemID, loadedCallback)
    end
    return itemInfo
end