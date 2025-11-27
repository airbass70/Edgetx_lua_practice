ThrId = getFieldInfo("thr").id				--ottiene il metaindece dal campo thr. getFieldInfo restiruisce una tabella record da cui peschiamo il field name "id", oppure nil se non trova niente.
t0 = 0			--lettura tempo dal precedente incremento/decremento dell'indice a
a = 1				--indice
return function()
  local t1 = getTime()
  local ThrVal = getValue(ThrId)	-- ottiene il valore di thr
  local Speed=math.abs(ThrVal)/10000	--step per centesimo di secondo
  if ThrVal >0 and t1>t0+(1/Speed) then
    a=a+1
    t0=t1
  elseif ThrVal <0 and t1>t0+(1/Speed) then
    a=a-1
    t0=t1
  end
  local field_id = getFieldInfo(a) and getFieldInfo(a).id or -1			--uguale a getFieldInfo(a)["id"]       ---	 
  local field_name = getFieldInfo(a) and getFieldInfo(a).name or "empty"	--sintactic sugar per dati tipo record ---
  local field_desc = getFieldInfo(a) and getFieldInfo(a).desc or "empty"
  
  lcd.clear()
  lcd.drawText(10,10,"id:",SMLSIZE)
  lcd.drawText(60,10,"val:",SMLSIZE)
  lcd.drawText(10,30,"name:",SMLSIZE)
  lcd.drawText(10,50,"Desc:",SMLSIZE)
  lcd.drawNumber(40,10,field_id,SMLSIZE)
  lcd.drawText(40,30,field_name,SMLSIZE)
  lcd.drawText(40,50,field_desc,SMLSIZE)
  lcd.drawText(90,10,tostring(getValue(field_id)))
end

