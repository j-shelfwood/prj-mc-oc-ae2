-- load the necessary libraries
local component = require("component")
local GUI = require("GUI")

-- get a reference to the ME interface
local meInterfaceAddress = component.list("me_interface")()

-- check if the ME Interface is connected
if not meInterfaceAddress then
    print("ME Interface not detected. Please check the connection.")
    return
end

-- if it is connected, create the proxy and continue with the script
local meInterface = component.proxy(meInterfaceAddress)

-- get the items in the network and sort them
local items = meInterface.getItemsInNetwork()
table.sort(items, function(a, b) return a.size > b.size end)

-- initialize the application and a layout for our items
local application = GUI.application()
local layout = application:addChild(GUI.layout(1, 1, application.width, application.height, 1, 1))

-- helper function to add a page of items to the layout
local function addPage(page)
    local start = (page - 1) * 10 + 1
    local finish = math.min(start + 9, #items)
    for i = start, finish do
        layout:addChild(GUI.text(1, 1, 0xFFFFFF, items[i].label .. ": " .. items[i].size))
    end
end

-- add the first page of items
addPage(1)

-- add navigation buttons
local previousButton = application:addChild(GUI.button(1, application.height, 10, 1, 0xFFFFFF, 0x555555, 0x880000,
    0xFFFFFF, "< Previous"))
previousButton.onTouch = function()
    layout:removeChildren()
    addPage(math.max(1, currentPage - 1))
    application:draw(true)
end

local nextButton = application:addChild(GUI.button(application.width - 9, application.height, 10, 1, 0xFFFFFF, 0x555555,
    0x880000, 0xFFFFFF, "Next >"))
nextButton.onTouch = function()
    layout:removeChildren()
    addPage(math.min(math.ceil(#items / 10), currentPage + 1))
    application:draw(true)
end

-- start the application
application:draw(true)
application:start()
