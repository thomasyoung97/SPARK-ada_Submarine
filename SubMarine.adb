package body SubMarine
with SPARK_Mode
is


----- DOOR CONTROL --------------------------------------------------
   procedure openInnerDoor is
   begin


      if(DoorOuter.open_close = Open) then


         DoorOuter.open_close := closed;
         DoorOuter.locked_unlocked := locked;

      end if;


      if(DoorInner.locked_unlocked = locked) then


         DoorInner.locked_unlocked := unlocked;


      end if;

      DoorInner.open_close := Open;


   end openInnerDoor;


   procedure closeInnerDoor is
   begin

      DoorInner.open_close := closed;
      DoorInner.locked_unlocked := locked;

   end closeInnerDoor;


   procedure openOuterDoor is
   begin

      if(DoorInner.open_close = Open) then


         DoorInner.open_close := closed;
         DoorInner.locked_unlocked := locked;

      end if;

      if(DoorOuter.locked_unlocked = locked) then

         DoorOuter.locked_unlocked := unlocked;

      end if;


      DoorOuter.open_close := Open;


   end openOuterDoor;


   procedure closeOuterDoor is
   begin

      DoorOuter.open_close := closed;
      DoorOuter.locked_unlocked := locked;

   end closeOuterDoor;

   ---- END DOOR CONTROL -----------------------------------------------------




   ----- SYSTEM WARNING CHECKS ---------------------------------------------
   procedure CheckOxygen is
   begin


         if (OxygenLevel <= warningLevel and O2Warning.on_Off = Off) then

            initiateO2Warning;

         end if;


         if(OxygenLevel = EmptyOxygen) then

            Surface;

         end if;

   end CheckOxygen;

   procedure CheckRectorTemp is
   begin
      if (currentTemp >= warningTemp and TempWarning.on_Off = Off ) then

         initiateTempWarning;

      end if;

      if(currentTemp >= maxSafeTemp) then

         Surface;

      end if;

   end CheckRectorTemp;

   procedure initiateO2Warning is
   begin
      O2Warning.on_Off := On;
   end initiateO2Warning;

   procedure initiateTempWarning is
   begin
      TempWarning.on_Off := On;
   end initiateTempWarning;

   ----- END SYSTEM WARNING CHECKS -------------------------------------------






   ------- LOCOMOTION CONTROL ------------------------------------------------------
   procedure Surface is
   begin

      while CurrentDepth > Depth'First loop

         CurrentDepth := CurrentDepth - 1;

      end loop;

   end Surface;


   procedure SetDepth (A : in Depth) is
   begin

      if(A <= maxDepth) then

        CurrentDepth := A;

      end if;

   end SetDepth;


   procedure SetSpeed (A : in Speed) is
   begin

      CurrentSpeed := A;

      end SetSpeed;

   procedure FineDepthControll (DLever : in DepthLever) is begin

      if(CurrentDepth < maxDepth - 1) then

      if(DLever = Forward) then
         CurrentDepth := CurrentDepth + 1;
         end if;

      end if;

      if(CurrentDepth > Depth'First + 1) then

      if(DLever = Backwards) then
         CurrentDepth := CurrentDepth + 1;
      end if;
      end if;


      end FineDepthControll;
   ---------- END DIVE CONTROL ------------------------------------------------

   procedure fireVolley (C : in out chambers) is

   begin

      for i in Chambered_index'Range loop

         C(i):= Empty;
      end loop;

   end fireVolley;


   procedure fireSingleTorpeado(TI: in Chambered_index; C :in out chambers)
   is
   begin


      C(TI) := Empty;



   end fireSingleTorpeado;


   procedure loadChamber (TI : in Chambered_index; C: in out chambers)
   is

   begin
          POPAMMO;
          C(TI) := Loaded;

   end loadChamber;




   procedure POPAMMO is

   begin


      for i in 0..(gAmmoStore'Last -1)   loop
         gAmmoStore(i) := gAmmoStore(i + 1);
      end loop;

      gAmmoStore(gAmmoStore'last) := Empty;

   end POPAMMO;

   procedure PUSHAMMO is

   begin

      for i in reverse (gAmmoStore'First + 1)..(gAmmoStore'Last) loop

         gAmmoStore(i) := gAmmoStore(i - 1);

      end loop;

      gAmmoStore(gAmmoStore'First) := Loaded;

   end PUSHAMMO;

   ---- END WEAPON CONROLS -------------------------------------------

   procedure SmoothTurn is begin

      -- if steering right
      while(steeringWheelMidPoint > (Steering'Last / 2)) loop

         -- if nose goes past 360 then reset to 1.
         if(NoseRotation = (SubXNoseRotation'Last)) then

            NoseRotation := SubXNoseRotation'First;
         else
            NoseRotation := NoseRotation + 1;

         end if;
      end loop;

         -- when steering hard right
         while(NoseRotation = (SubXNoseRotation'Last / 2 + (SubXNoseRotation'Last / 3))) loop

           if(NoseRotation = (SubXNoseRotation'Last)) then

            NoseRotation := SubXNoseRotation'First;
         else
            NoseRotation := NoseRotation + 4;

         end if;


      end loop;

      -- if steering wheel is turning left
         while (steeringWheelMidPoint < (Steering'Last / 2)) loop

         -- if rotation goes past 1 then set to 360;
         if(NoseRotation = (SubXNoseRotation'First)) then

            NoseRotation := SubXNoseRotation'Last;
         else
            NoseRotation := NoseRotation - 1;

         end if;


      end loop;


   while (steeringWheelMidPoint < (Steering'Last / 2) - (Steering'Last / 3)) loop

         -- if rotation goes past 1 then set to 360;
         if(NoseRotation = (SubXNoseRotation'First)) then

            NoseRotation := SubXNoseRotation'Last;
         else
            NoseRotation := NoseRotation - 4;

         end if;


      end loop;

   end SmoothTurn;

   procedure SnapTurn (D : in Direction) is begin
      Case D is
         when Forward => SubDirection := Forward;
         when Aft => SubDirection := Aft;
         when Starboard => SubDirection := Starboard;
         when Port => SubDirection := Port;

      end case;
      end SnapTurn;

end SubMarine;
