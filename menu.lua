local script_folder = "/SCRIPTS/TELEMETRY/MYPRACTICE"  
local currentOption = 1
local selectionIsDone = false
local myscripts={"field.lua"}
local executeScript={}
local numberOfOptions=#myscripts



local function drawMenuScreen()
    lcd.clear()
    for i=1,numberOfOptions do
        lcd.drawText(1,1+12*(i-1),"1: "..myscripts[i],(currentOption == i and INVERS or 0))
    end
end

for i=1,numberOfOptions do
    executeScript[i]=loadScript(script_folder.."/"..myscripts[i])()
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
            firstRun = true --mi serve al posto di init negli script che carico dalla cartella MYPRACTICE
            selectionIsDone = true
        end
    elseif selectionIsDone then
        executeScript[currentOption]()
        if event == EVT_EXIT_BREAK then SelectionIsDone = false end
    end
end

return {run=run}
