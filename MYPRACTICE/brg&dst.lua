--[[
Mirano
45.494444 Nord  12.104722 Est
45° 29' 40" Nord  12° 06' 17" Est  
Noale
45.553333 Nord  12.071944 Es
45° 33' 12" Nord  12° 04' 19" Est
--]]

local R = 6371  --Radius of the earth in M

local waypoint={}
waypoint.lat=45.493  waypoint.lon=12.109

local position={}
position.lat=45.55   position.lon=12.07

local source={}
source.ail=getFieldInfo("ail")  source.ele=getFieldInfo("ele")

local t0=0

local function getPos()       -- input per testare il programma al posto delle variabili tele

  source.ail.value=getValue(source.ail.id)
  source.ele.value=getValue(source.ele.id)

  local lon_rate=source.ail.value/1024
  local lat_rate=source.ele.value/1024
  local t=getTime()/100/60
  local dt=t-t0
  position.lat=position.lat+lat_rate*dt
  position.lon=position.lon+lon_rate*dt
  local currentPos={}
  currentPos.lat=position.lat
  currentPos.lon=position.lon
  t0=t
  return currentPos
end

local function getBrg_Dst(lat1,lon1,lat2,lon2)
  local d_phi = math.rad(lat2-lat1)
  local d_lam = math.rad(lon2-lon1)
  local phi1 = math.rad(lat1)
  local phi2 = math.rad(lat2)
  --distanza formula degli Haversine
  local c= (1 - math.cos(d_phi) + math.cos(phi1) * math.cos(phi2) * (1 - math.cos(d_lam)))/2
  local b= math.sqrt(c)
  local a= math.asin(b)
  local d= 2*R*a*1000
  --rilevamento vero regola dei coseni
  local y = math.sin(d_lam) * math.cos(phi2);
  local x = math.cos(phi1)*math.sin(phi2) - math.sin(phi1)*math.cos(phi2)*math.cos(d_lam)
  local the = math.atan2(y, x)
  local brng = (the*180/math.pi + 360) % 360  -- in degrees
  local pos={}
  pos.distance=d
  pos.bearing=brng
  return pos
end

return function()
  lcd.clear()
  lcd.drawText(10,10,string.format("%.4f",tostring(waypoint.lat)), 0)
  lcd.drawText(50,10,string.format("%.4f",tostring(waypoint.lon)), 0)
  lcd.drawText(10,25,string.format("%.4f",tostring(getPos().lat)), 0)
  lcd.drawText(50,25,string.format("%.4f",tostring(getPos().lon)), 0)
  lcd.drawText(10,40,string.format("%.2f",tostring(getBrg_Dst(getPos().lat,getPos().lon,waypoint.lat,waypoint.lon).distance)), 0)
  lcd.drawText(10,55,string.format("%1d",tostring(getBrg_Dst(getPos().lat,getPos().lon,waypoint.lat,waypoint.lon).bearing)), 0)
end

