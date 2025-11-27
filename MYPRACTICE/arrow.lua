local RudId = getFieldInfo("rud").id
--local arrowPoints={0,1,0.7,-0.7,0,-0.3,-0.7,-0.7,0,1}  --  CURSORE coordinate vertici  (x1,y1,...xn,yn)
local arrowPoints={0,1,1,0,0.4,0,0.4,-1,-0.4,-1,-0.4,0,-1,0,0,1}  -- FRECCIA coordinate vertici  (x1,y1,...xn,yn)
local arrowPos={60,30}
local arrowScale=6
local arrowResized={}
for i=1,#arrowPoints do
	arrowResized[i]=arrowPoints[i]*arrowScale
end

return function()
	local bearing = getValue(RudId)/1024*180
	local rndBearing=math.floor(bearing+180)   --arrotonda all'intero più vicino. Solo per numeri positivi.
	local theta=math.rad(rndBearing)
	local arrowRotaded={}
	for i=1,#arrowResized-1,2 do
		arrowRotaded[i]=arrowResized[i]*math.cos(theta)-arrowResized[i+1]*math.sin(theta)
		arrowRotaded[i+1]=arrowResized[i]*math.sin(theta)+arrowResized[i+1]*math.cos(theta)
	end
	local arrow={}
	for i=1,#arrowRotaded-1,2 do
		arrow[i]=arrowRotaded[i]+arrowPos[1]
		arrow[i+1]=arrowRotaded[i+1]+arrowPos[2]
	end
		lcd.clear()
	for i=1,#arrow-3,2 do
		lcd.drawLine(arrow[i],arrow[i+1],arrow[i+2],arrow[i+3],SOLID,FORCE)
		lcd.drawText(5,5,rndBearing,SMLSIZE)
	end
end
