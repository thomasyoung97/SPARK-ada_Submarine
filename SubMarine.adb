package body SubMarine
with SPARK_Mode
is


   procedure popAmmo (A : in out AmmoStore) is
   begin

-- if end of stack is loaded pop that o
         if(A(A'Last) = Loaded) then

         A(A'Last) := Empty;

         end if;
        else
      -- if not find first empty,
            for i in A'Range loop

              if (A(i) = Empty)  then


                 if (i = A'First) then


                   exit; --AMMO STORE EMPTY


                 else


                    A(i - 1) := Empty;
                    exit;


                 end if;


              end if;

           end loop;

        end if;


   end popAmmo;

 -- returns the first index different to which the proceeding index is different
function GetfirstDifferent(A: in AmmoStore) return AS_Index is

begin


      for j in A'Range loop

         if(A(j) /= A(A'First)) then

            if(A(j) /= A(j - 1)) then

               return j;

            end if;
         end if;

      end loop;

      return A'First;

   end GetfirstDifferent;






























----- DOOR CONTROL --------------------------------------------------
   procedure openInnerDoor is
   begin

      if(DoorOuter.open_close = Open) then

         closeOuterDoor;

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

         closeInnerDoor;

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



   ------- DIVE CONTROL ------------------------------------------------------
   procedure Surface is
   begin

      while CurrentDepth > Depth'First loop

         CurrentDepth := CurrentDepth - 1;

      end loop;

   end Surface;


   procedure Dive (A : in Depth) is
   begin

      if(A + CurrentDepth < maxDepth) then

        CurrentDepth := CurrentDepth + A;

      end if;

   end Dive;

   ---------- END DIVE CONTROL ------------------------------------------------


   ---- WEAPON CONTROLS ----------------------------------------------
   procedure loadAllTorpeado (A : in out AmmoStore; C : in out chambers)
   is
      i : AS_Index := A'First;
      j : Chambered_index := C'First;

      FirstTorpeadoindex : AS_Index := A'First;
   begin

      --get index of first torpeado in ammo store.
      while i < A'Last loop
         if(A(i) = Loaded) then
            FirstTorpeadoindex := i;
         end if;
      end loop;


      -- get first empty chamber, move torpeado
      --from ammo store to chamber
      while  j < C'Last loop
         if (C(j) = Empty) then
            A(FirstTorpeadoindex) := Empty;
            C(j) := Loaded;
         end if;
      end loop;

   end loadAllTorpeado;


   procedure fireVolley (C : in out chambers) is
      i : Chambered_index := C'First;
   begin

      while(i < C'Last) loop

         C(i) := Empty;

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


            C(TI) := Loaded;




   end loadChamber;

   ---- END WEAPON CONROLS -------------------------------------------


end SubMarine;
