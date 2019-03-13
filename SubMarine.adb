package body SubMarine
with SPARK_Mode
is


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




   -----------------------------------------------------------------------------

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

   -----------------------------------------------------------------------------


   procedure CheckOxygen is
   begin
      if (OxygenLevel <= warningLevel) then
         null;
        --initiate warning
      end if;

      if(OxygenLevel <= EmptyOxygen) then
         null;
         -- surface
      end if;

   end CheckOxygen;


   procedure emergancySurface is
   begin

      while CurrentDepth > Depth'First loop
         CurrentDepth := CurrentDepth - 1;
      end loop;
   end emergancySurface;


end SubMarine;
