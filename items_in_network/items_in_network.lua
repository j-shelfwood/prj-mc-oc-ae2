-- load the necessary libraries
local component = require("component")

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

-- display the items
for i, item in ipairs(items) do
    print(i .. ": " .. item.label .. ", Count: " .. item.size)
end
