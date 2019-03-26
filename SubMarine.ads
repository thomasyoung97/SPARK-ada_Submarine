package SubMarine
with SPARK_Mode
is

   --depth monitor
   type Depth is range 0..1000;
   CurrentDepth : Depth := (Depth'Last / 2);
   maxDepth : Depth := Depth'Last;


   --oxegen monitor
   type Oxygen is range 0..100;
   OxygenLevel : Oxygen := Oxygen'Last;
   warningLevel : Oxygen := (Oxygen'Last / 100) * 10;
   EmptyOxygen : Oxygen := Oxygen'First;


   type SubXNoseRotation is range 1..360;
   type Steering is range 1..180;

   NoseRotation : SubXNoseRotation := (SubXNoseRotation'Last /2);
   steeringWheelMidPoint : Steering := (Steering'Last / 2);


   type Temperature is range 0..2000;
   currentTemp : Temperature := Temperature'Last / 2;
   maxSafeTemp : Temperature := (Temperature'Last /100) * 90;
   warningTemp : Temperature := (Temperature'Last /100) * 80;


   type TorpeadoBay is (Loaded, Empty);

   type Direction is (Forward, Aft , Port, Starboard);



   SubDirection : Direction := Forward;

   type AS_Index is range 0..25;
   type AmmoStore is array(AS_Index) of TorpeadoBay;
   gAmmoStore:AmmoStore;

   type Chambered_index is range  0..4;
   type chambers is array(Chambered_index) of TorpeadoBay;


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
          (if DoorOuter.open_close = Open then DoorInner.open_close = closed and DoorInner.locked_unlocked = locked and DoorOuter.locked_unlocked = unlocked));




   ---- END DOOR CONTROL --------------------------------------------------




   ---- SYSTEM WARNING CHECKS ----------------------------------------------

   procedure initiateO2Warning with
     Global => (In_Out => O2Warning),
     Pre => O2Warning.on_Off = Off,
     Post => O2Warning.on_Off = On;

   procedure CheckOxygen with
     Global => (Input => (OxygenLevel, warningLevel,EmptyOxygen),
                In_Out => (O2Warning, CurrentDepth));

   procedure initiateTempWarning with
     Global => (In_Out => TempWarning),
     Pre => TempWarning.on_Off = Off,
     Post => TempWarning.on_Off = On;

   procedure CheckRectorTemp with
     Global => (Input => (currentTemp,warningTemp,maxSafeTemp),
                In_Out => (TempWarning, CurrentDepth));

   --- END SYSTEM WARNING CHECKS ------------------------------------------



   --- DIVE CONTROLS ------------------------------------------------------

   procedure Surface with
     Global => (In_Out => CurrentDepth),
     Pre => CurrentDepth >= Depth'First,
     Post => CurrentDepth <= Depth'First;


   procedure SetDepth  (A : in Depth) with
     Global => (In_Out => CurrentDepth , Input => maxDepth),
     Pre => CurrentDepth <= maxDepth,
     Post => CurrentDepth <= maxDepth and CurrentDepth >= Depth'First;

  ---- END DIVE CONTROLS ---------------------------------------------------

  --- Turning controlls ----------------------------------------------------
   procedure SnapTurn (D : in Direction)with
     Global =>(In_Out => SubDirection),
     Pre => (D /= SubDirection),
     Post => (SubDirection =  D);


   procedure Smoothturn with
     Global => (Input => steeringWheelMidPoint, In_Out => NoseRotation),
     Post => (NoseRotation <= SubXNoseRotation'Last);

   ---- WEAPON CONTROLLS ---------------------------------------------------

   --procedure loadAllTorpeado (A : in out AmmoStore ; C : in out chambers) with
     --Pre => (for some j in A'Range => A(j)  = Loaded) and
     --(for some k in C'Range => C(k) = Empty),
     --Post => (for some i in C'Range => C(i) = Loaded);

   procedure fireVolley (C : in out chambers) with
     Pre => (for some i in C'Range => C(i) = Loaded),
     Post => (for all j in C'Range => C(j) = Empty);


   procedure PUSHAMMO with
     Global=> (In_Out => gAmmoStore),
     Pre => gAmmoStore(gAmmoStore'Last) = Empty,
     Post => gAmmoStore(gAmmoStore'First) = Loaded;


   procedure POPAMMO with
     Global => (In_Out => (gAmmoStore)),
     Pre => (gAmmoStore(gAmmoStore'First) = Loaded),
     Post => (gAmmoStore(gAmmoStore'Last) = Empty);





   --takes chambered torpeado index and fires it providing its not empty
   procedure fireSingleTorpeado (TI : in Chambered_index; C: in out chambers) with
     Pre => (C(TI) = Loaded),
     Post => (C(TI) = Empty);


   procedure loadChamber (TI : in Chambered_index; C: in out chambers) with
     Global => (In_Out => gAmmoStore),
     Pre => (C(TI) = empty) and (gAmmoStore(gAmmoStore'First) = Loaded),
     Post => (C(TI) = Loaded) and (for all i in C'Range => (if i /= TI then C(i) = c'Old(i)));

   --- WEAPON CONTROLLS ----------------------------------------------------



end SubMarine;
