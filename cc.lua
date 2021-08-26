---@meta
---@class cc
local cc = {}
---@class CCOptions
local CCOptions = {}
---@class CCWeights
local CCWeights = {}
---@class CCBot
local CCBot = {}


---@return CCOptions
---@return CCWeights
function cc.getDefaultConfig() end

---@param options CCOptions
---@param weights CCWeights
---@return CCBot
function cc.launchAsync(options, weights) end

---@return string
function cc.about() end


---@param bot CCBot
---@param field boolean[]
---@param b2b boolean
---@param combo integer
function CCBot:reset(bot, field, b2b, combo) end

---@param piece integer
function CCBot:addNext(piece) end

---@param incoming? integer
function CCBot:think(incoming) end

---@return integer status
---@return boolean hold
---@return integer[] move
function CCBot:getMove() end

---@return integer status
---@return boolean hold
---@return integer[] move
function CCBot:blockNextMove() end


function CCOptions.defaultOptions() end

---@param canhold boolean
---@param is20g boolean
---@param isbag7 boolean
function CCOptions:setOptions(canhold, is20g, isbag7) end

---@param canhold boolean
function CCOptions:setHold(canhold) end

---@param is20g boolean
function CCOptions:set20G(is20g) end

---@param isbag7 boolean
function CCOptions:setBag(isbag7) end

---@param ispcloop boolean
function CCOptions:setPCLoop(ispcloop) end

---@param nodes integer
function CCOptions:setNode(nodes) end


function CCWeights:defaultWeights() end

---@param key string
---@param value number
function CCWeights:setWeights(key, value) end

function CCWeights:fastWeights() end

return cc
