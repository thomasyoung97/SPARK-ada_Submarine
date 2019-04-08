package SubMarine
with SPARK_Mode
is

   --depth monitor
   type Depth is range 0..1000;
   CurrentDepth : Depth := (Depth'Last / 2);
   maxDepth : Depth := Depth'Last;

   type DepthLever is (Forward, Backwards);
   Dlever : DepthLever;

   type Speed is range -100..100;
   CurrentSpeed : Speed := (Speed'Last / 2);

   --oxegen monitor
   type Oxygen is range 0..100;
   OxygenLevel : Oxygen := Oxygen'Last;
   warningLevel : constant Oxygen := (Oxygen'Last / 100) * 10;
   EmptyOxygen : constant Oxygen := Oxygen'First;


   type SubXNoseRotation is range 1..360;
   type Steering is range 1..180;

   NoseRotation : SubXNoseRotation := (SubXNoseRotation'Last /2);
   steeringWheelMidPoint : Steering := (Steering'Last / 2);


   type Temperature is range 0..2000;
   currentTemp : Temperature := Temperature'Last / 2;
   maxSafeTemp : constant Temperature := (Temperature'Last /100) * 90;
   warningTemp : constant Temperature := (Temperature'Last /100) * 80;

   hasFired : Boolean := False;

   type TorpeadoBay is (Loaded, Empty);

   type Direction is (Forward, Aft , Port, Starboard);


   SubDirection : Direction := Forward;

   type AS_Index is range 0..25;
   type AmmoStore is array(AS_Index) of TorpeadoBay;
   gAmmoStore:AmmoStore;

   type Chambered_index is range  0..4;
   type chambers is array(Chambered_index) of TorpeadoBay;
   TChambers : chambers;

   type OpenClose is (Open , closed);
   type lock is (locked, unlocked);
   type onoff is (On, Off);

   temp:AS_Index;


   type door is record
      open_close : OpenClose;
      locked_unlocked : lock;
   end record;


   DoorInner : door := (open_close => closed, locked_unlocked => locked);
   DoorOuter : door := (open_close => closed, locked_unlocked => locked);


   type Warning is record
      on_Off :  onoff;
   end record;


   O2Warning : Warning := (on_Off => Off);
   TempWarning : Warning := (on_Off => Off);




   ------ DOOR CONTROL ------------------------------------------
   procedure openInnerDoor with
     Global => (In_Out => (DoorInner,DoorOuter)),
     Pre => DoorInvairance(DoorOuter, DoorInner),
     Post => DoorInvairance(DoorOuter, DoorInner);

   procedure closeInnerDoor with
     Global => (In_Out => DoorInner, Input => DoorOuter),
     Pre => DoorInvairance(DoorOuter, DoorInner),
     Post => DoorInvairance(DoorOuter, DoorInner);

   procedure openOuterDoor with
    Global => (In_Out => (DoorInner, DoorOuter)),
     Pre => DoorInvairance(DoorOuter, DoorInner) ,
     Post => DoorInvairance(DoorOuter, DoorInner);

   procedure closeOuterDoor with
     Global => (In_Out =>  DoorOuter , Input => DoorInner),
     Pre => DoorInvairance(DoorOuter, DoorInner),
     Post => DoorInvairance(DoorOuter, DoorInner);


   function DoorInvairance (DoorOuter : in door ; DoorInner : in  door) return Boolean is
     ((if DoorInner.open_close = Open then DoorOuter.open_close = closed and DoorOuter.locked_unlocked = locked and DoorInner.locked_unlocked = unlocked) or
          (if DoorOuter.open_close = Open then DoorInner.open_close = closed and DoorInner.locked_unlocked = locked and DoorOuter.locked_unlocked = unlocked) or
          (DoorOuter.open_close = closed and DoorOuter.locked_unlocked = locked and DoorInner.open_close = closed and DoorInner.locked_unlocked = locked));

   function BothDoorsClosed(DoorOuter : in door ; DoorInner : in  door) return Boolean is
     ((DoorOuter.open_close = closed and DoorOuter.locked_unlocked = locked) and (DoorInner.open_close = closed and DoorInner.locked_unlocked = locked));

   ---- END DOOR CONTROL --------------------------------------------------






   ---- SYSTEM WARNING CHECKS ----------------------------------------------

   procedure initiateO2Warning with
     Global => (Input => (DoorOuter,DoorInner), In_Out => O2Warning),
     Pre => BothDoorsClosed(DoorOuter,DoorInner)and O2Warning.on_Off = Off,
     Post => O2Warning.on_Off = On;


   procedure CheckOxygen with
     Global => (Input => (OxygenLevel,DoorInner,DoorOuter),
                In_Out => (O2Warning, CurrentDepth)),
     Pre => BothDoorsClosed(DoorOuter,DoorInner),
     Post => (if OxygenLevel = EmptyOxygen then CurrentDepth = Depth'First) and ((if OxygenLevel <= warningLevel then O2Warning.on_Off = on)
                                                                                 or (if OxygenLevel > warningLevel then O2Warning.on_Off = Off));


   procedure initiateTempWarning with
     Global => (In_Out => TempWarning , Input => (DoorOuter,DoorInner)),
     Pre => TempWarning.on_Off = Off and BothDoorsClosed(DoorOuter,DoorInner),
     Post => TempWarning.on_Off = On;


   procedure CheckRectorTemp with
     Global => (Input => (currentTemp,DoorInner,DoorOuter),
                In_Out => (TempWarning, CurrentDepth)),
     Pre =>BothDoorsClosed(DoorOuter,DoorInner),
     Post => (if currentTemp = maxSafeTemp then CurrentDepth = Depth'First) and ((if currentTemp >= warningTemp then TempWarning.on_Off = on)
                                                                                 or (if currentTemp < warningTemp then TempWarning.on_Off = Off));


   --- END SYSTEM WARNING CHECKS -----------------------------------------------




   --- LOCOMOTION CONTROLS ------------------------------------------------------

   procedure Surface with
     Global => (In_Out => (CurrentDepth), Input => (DoorInner,DoorOuter)),
     Pre => CurrentDepth >= Depth'First and BothDoorsClosed(DoorOuter,DoorInner),
     Post => CurrentDepth <= Depth'First;


   procedure SetDepth  (A : in Depth) with
     Global => (In_Out => CurrentDepth , Input => (maxDepth,DoorOuter,DoorInner)),
     Pre => CurrentDepth + A <= maxDepth and BothDoorsClosed(DoorOuter,DoorInner),
     Post => CurrentDepth <= maxDepth and CurrentDepth >= Depth'First;


   procedure FineDepthControll (DLever : in DepthLever)with
     Global => (In_Out => CurrentDepth , Input => (maxDepth,DoorOuter,DoorInner)),
     Pre => (CurrentDepth < maxDepth and CurrentDepth > Depth'First) and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (CurrentDepth <= maxDepth and CurrentDepth > Depth'First);


   procedure SetSpeed (A : in Speed) with
     Global => (Output => CurrentSpeed),
     Pre => (A < Speed'Last),
     Post => (CurrentSpeed = A);


  ---- END LOCOMOTION CONTROLS ---------------------------------------------------




  --- Turning controlls ----------------------------------------------------
   procedure SnapTurn (D : in Direction)with
     Global =>(In_Out => SubDirection, Input => (DoorInner,DoorOuter)),
     Pre => (D /= SubDirection) and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (SubDirection =  D);


   procedure Smoothturn with
     Global => (Input => (steeringWheelMidPoint,DoorInner,DoorOuter), In_Out => NoseRotation),
     Pre => BothDoorsClosed(DoorOuter,DoorInner),
     Post => (if steeringWheelMidPoint > (Steering'Last / 4) then NoseRotation > NoseRotation'Old) or
     (if steeringWheelMidPoint > (Steering'Last / 2) then NoseRotation < NoseRotation'Old);


   ---- WEAPON CONTROLLS ---------------------------------------------------
   procedure fireVolley (C : in out chambers) with
     Pre => (for some i in C'Range => C(i) = Loaded) and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (for all j in C'Range => C(j) = Empty);

   procedure PUSHAMMO with
     Global=> (In_Out => gAmmoStore , Input => (DoorInner,DoorOuter)),
     Pre => gAmmoStore(gAmmoStore'Last) = Empty and BothDoorsClosed(DoorOuter,DoorInner),
     Post => gAmmoStore(gAmmoStore'First) = Loaded;



   procedure POPAMMO with
     Global => (In_Out => (gAmmoStore), Input => (DoorInner, DoorOuter)),
     Pre => (gAmmoStore(gAmmoStore'First) = Loaded) and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (gAmmoStore(gAmmoStore'Last) = Empty);


   --takes chambered torpeado index and fires it providing its not empty
   procedure fireSingleTorpeado (TI : in Chambered_index; C: in out chambers) with
     Global => (Input => (DoorInner, DoorOuter)),
     Pre => (C(TI) = Loaded)  and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (C(TI) = Empty);


   procedure loadChamber (TI : in Chambered_index; C: in out chambers) with
     Global => (In_Out => gAmmoStore, Input => (DoorOuter,DoorInner)),
     Pre => (C(TI) = empty) and (gAmmoStore(gAmmoStore'First) = Loaded) and BothDoorsClosed(DoorOuter,DoorInner),
     Post => (C(TI) = Loaded) and (for all i in C'Range => (if i /= TI then C(i) = c'Old(i)));

   --- WEAPON CONTROLLS ----------------------------------------------------



end SubMarine;
