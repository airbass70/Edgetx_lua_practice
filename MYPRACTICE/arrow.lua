--[[
=========
==arrow==
=========
rev 1.1 27 Feb 2025
	Riccardo Airbass
Telemetry script esercitazione sul comando draw line e la matrice di rotazione. Disegna l'indicatore grafico a freccia da usare come indicatore di rilevamento polare (per es. home). Provato su Radiomaster Boxer. Input angolo rotazione con stick rudder
--]]


if firstRun then
  RudId = getFieldInfo("rud").id
  --local arrowPoints={0,1,0.7,-0.7,0,-0.3,-0.7,-0.7,0,1}  --  CURSORE coordinate vertici  (x1,y1,...xn,yn)
  arrowPoints={0,1,1,0,0.4,0,0.4,-1,-0.4,-1,-0.4,0,-1,0,0,1}  -- FRECCIA coordinate vertici  (x1,y1,...xn,yn)
  arrow={}
  arrowPos={60,30}
  arrowScale=6
  arrowResized={}
  arrowRotaded={}
  firstRun = false
  for i=1,#arrowPoints do
    arrowResized[i]=arrowPoints[i]*arrowScale
  end
end
local bearing = getValue(RudId)/1024*180
local rndBearing=math.floor(bearing+180)   --arrotonda all'intero più vicino. Solo per numeri positivi.
local theta=math.rad(rndBearing)
for i=1,#arrowResized-1,2 do
  arrowRotaded[i]=arrowResized[i]*math.cos(theta)-arrowResized[i+1]*math.sin(theta)
  arrowRotaded[i+1]=arrowResized[i]*math.sin(theta)+arrowResized[i+1]*math.cos(theta)
end
for i=1,#arrowRotaded-1,2 do
  arrow[i]=arrowRotaded[i]+arrowPos[1]
  arrow[i+1]=arrowRotaded[i+1]+arrowPos[2]
end
lcd.clear()
for i=1,#arrow-3,2 do
  lcd.drawLine(arrow[i],arrow[i+1],arrow[i+2],arrow[i+3],SOLID,FORCE)
end
