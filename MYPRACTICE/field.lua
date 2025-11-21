--[[
================
==   FIELD    ==
================
Airbass70

Telemetry script per ottenere la descrizione completa ed il valore dei field di edgetx in funzione del loro metaindice.
Usare lo stick thr su e giu per cambiare l'indice
Ogni tanto ci sono delle posizioni vuote.
--]]

if firstRun then
  Field_id			--metaindice del campo
  Field_name		--nome del campo
  field_desc		--descrizione del campo
  ThrId = getFieldInfo("thr").id				--ottiene il metaindece dal campo thr. getFieldInfo restiruisce una tabella record da cui peschiamo il field name "id", oppure nil se non trova niente.
  t0 = 0				--lettura tempo dal precedente incremento/decremento dell'indice a
  t1				--lettura tempo da controllare
  a	= 1				--indice da ottenere
  firstRun = false
end

t1 = getTime()
ThrVal = getValue(ThrId)	-- ottiene il valore di thr
Speed=math.abs(ThrVal)/10000			--step per centesimo di secondo
if ThrVal >0 and t1>t0+(1/Speed) then
  a=a+1
  t0=t1
elseif ThrVal <0 and t1>t0+(1/Speed) then
  a=a-1
  t0=t1
end
  
lcd.clear()
field_id = getFieldInfo(a) and getFieldInfo(a).id or -1			--uguale a getFieldInfo(a)["id"]       ---	 	
field_name = getFieldInfo(a) and getFieldInfo(a).name or "empty"	--sintactic sugar per dati tipo record ---
field_desc = getFieldInfo(a) and getFieldInfo(a).desc or "empty"	

lcd.drawText(10,10,"id:",SMLSIZE)
lcd.drawText(60,10,"val:",SMLSIZE)
lcd.drawText(10,30,"name:",SMLSIZE)
lcd.drawText(10,50,"Desc:",SMLSIZE)
lcd.drawNumber(40,10,field_id,SMLSIZE)
lcd.drawText(40,30,field_name,SMLSIZE)
lcd.drawText(40,50,field_desc,SMLSIZE)
lcd.drawText(90,10,tostring(getValue(field_id)))
