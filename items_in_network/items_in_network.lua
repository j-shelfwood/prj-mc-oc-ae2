-- load the necessary libraries
local component = require("component")

-- get a reference to the AE2 interface
local meInterface = component.proxy(component.list("me_interface")())

-- get the items in the network and sort them
local items = meInterface.getItemsInNetwork()
table.sort(items, function(a, b) return a.size > b.size end)

-- display the items
for i, item in ipairs(items) do
    print(i .. ": " .. item.label .. ", Count: " .. item.size)
end
