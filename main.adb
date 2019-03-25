with SubMarine;
with ada.Text_IO;
use ada.Text_IO;
use SubMarine;
procedure Main is
  
begin
  
  
   
   for i in gAmmoStore'Range loop
      
      gAmmoStore(i):= Loaded;
      
   end loop;
   
      gAmmoStore(4) := Empty;
   
   temp := 13;
     --GetfirstDifferent(gAmmoStore);
   
   
end Main;
