local script_folder = "/SCRIPTS/TELEMETRY/MYPRACTICE"  
local currentOption = 1
local selectionIsDone = false
local myscripts={"field.lua","arrow.lua","brg&dst"}
local executeScript={}
local numberOfOptions=#myscripts



local function drawMenuScreen()
    lcd.clear()
    lcd.drawText(1,1,"SELECT A SCRIPT TO RUN",INVERS,SMLSIZE)
    for i=1,numberOfOptions do
        lcd.drawText(1,10+10*(i-1),"1: "..myscripts[i],(currentOption == i and INVERS or 0))
    end
end

for i=1,numberOfOptions do
    executeScript[i]=loadScript(script_folder.."/"..myscripts[i])()  --the script creates the closure function to iterate in run(), and the upvalues
end

local function run(event)
    if not selectionIsDone then
        if event == EVT_ROT_RIGHT then
            currentOption=currentOption + 1
            if currentOption>numberOfOptions then currentOption=1 end
        elseif event == EVT_ROT_LEFT then
            currentOption=currentOption - 1
            if currentOption<1 then currentOption=numberOfOptions end
        end
        drawMenuScreen()
        if event == EVT_ROT_BREAK then
            lcd.clear()
            selectionIsDone = true
        end
    elseif selectionIsDone then
        executeScript[currentOption]()  --calls the closure function. It keeps the state between iterations. Upvalues variables keep their values across successive calls. 
        if event == EVT_EXIT_BREAK then
            selectionIsDone = false
        end
    end
end

return {run=run}
