local script_folder = "/SCRIPTS/TELEMETRY/MYPRACTICE"  
local NumberOfOptions= 4
local currentOption = 1
local SelectionIsDone = false
local myscripts={}
myscripts[2]="field.lua"


local function drawMenuScreen()
    lcd.clear()
    lcd.drawText(1,1,"1: pippo",(currentOption == 1 and INVERS or 0))
    lcd.drawText(1,12,"2: field",(currentOption == 2 and INVERS or 0))
    lcd.drawText(1,24,"3: topolino",(currentOption == 3 and INVERS or 0))
    lcd.drawText(1,36,"4: paperino",(currentOption == 4 and INVERS or 0))
end

local function run(event)
    if not SelectionIsDone then
        if event == EVT_ROT_RIGHT then
            currentOption=currentOption + 1
            if currentOption>NumberOfOptions then currentOption=1 end
        elseif event == EVT_ROT_LEFT then
            currentOption=currentOption - 1
            if currentOption<1 then currentOption=NumberOfOptions end
        end
        drawMenuScreen()
        if event == EVT_ROT_BREAK then
            lcd.clear()
            firstRun = true --mi serve al posto di init negli script che carico dalla cartella MYPRACTICE
            SelectionIsDone = true
        end
    elseif SelectionIsDone then
        loadScript(script_folder.."/"..myscripts[currentOption])()        
    end
end

return {run=run}
