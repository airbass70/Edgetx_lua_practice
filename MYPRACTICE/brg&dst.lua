--[[
Mirano
45.494444 Nord  12.104722 Est
45° 29' 40" Nord  12° 06' 17" Est  
Noale
45.553333 Nord  12.071944 Es
45° 33' 12" Nord  12° 04' 19" Est
--]]

local R = 6371e3 -- metres

local waypoint={["lat"]=45.493, ["lon"]=12.109}
local position={["lat"]=45.55, ["lon"]=12.07}

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
  t0=t
  return position
end

local function getBrg_Dst(lat1,lon1,lat2,lon2)
  local phi1 = lat1 * math.pi/180 -- φ, λ in radians
  local phi2 = lat2 * math.pi/180
  local d_phi = (lat2-lat1) * math.pi/180
  local d_lam = (lon2-lon1) * math.pi/180
  -- calcolo distanza con la formula degli haverseni
  local a = math.sin(d_phi/2) * math.sin(d_phi/2) +
          math.cos(phi1) * math.cos(phi2) *
          math.sin(d_lam/2) * math.sin(d_lam/2)
  local c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
  local d = R * c  -- in metres
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
  local dist = getBrg_Dst(getPos().lat,getPos().lon,waypoint.lat,waypoint.lon).distance
    lcd.clear()
  lcd.drawText(10,1,string.format("WayPt %.3f  %.3f",tostring(waypoint.lat),tostring(waypoint.lon)), 0)
  lcd.drawText(10,20,string.format("%d°",tostring(getBrg_Dst(getPos().lat,getPos().lon,waypoint.lat,waypoint.lon).bearing)),0)
  lcd.drawText(10,40,dist >= 1000 and string.format("%.2f km",tostring(dist/1000)) or string.format("%d m",tostring(dist)), 0)
  lcd.drawText(10,55,string.format("Pos %.3f %.3f",tostring(getPos().lat),tostring(getPos().lon)), 0)
end
