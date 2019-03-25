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



   type Temperature is range 0..2000;
   currentTemp : Temperature := Temperature'Last / 2;
   maxSafeTemp : Temperature := (Temperature'Last /100) * 90;
   warningTemp : Temperature := (Temperature'Last /100) * 80;


   type TorpeadoBay is (Loaded, Empty);



   type AS_Index is range 0..25;
   type AmmoStore is array(AS_Index) of TorpeadoBay;


   type Chambered_index is range  0..4;
   type chambers is array(Chambered_index) of TorpeadoBay;


   type OpenClose is (Open , closed);
   type lock is (locked, unlocked);
   type onoff is (On, Off);



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




   procedure popAmmo (A : in out AmmoStore) with
     Pre => (invairantA(A)) or (for all i in A'Range => A(i) = Loaded),
     Post => invairantA(A) and (for some i in A'Range => A(i) = Empty);



   function GetfirstDifferent (A: in AmmoStore) return AS_index;



   function invairantA (A : in AmmoStore) return boolean is
     (for all i in GetfirstDifferent(A)..A'Last => A(i) = A(GetfirstDifferent(A)));
     --(for some i in A'Range => i < A'Last
      --and A(i) /= A(i - 1) and (for all j in i..A'Last => A(j) = A(i)));



   ------ DOOR CONTROL ------------------------------------------
   procedure openInnerDoor with
     Global => (In_Out => (DoorInner,DoorOuter)),
     Pre => DoorInner.open_close = closed,
     Post => DoorInner.open_close = open and DoorOuter.open_close = closed
     and DoorInner.locked_unlocked = unlocked;


   procedure closeInnerDoor with
     Global => (In_Out => DoorInner),
     Pre => DoorInner.open_close = Open,
     Post => DoorInner.open_close = closed
     and  DoorInner.locked_unlocked = locked;


   procedure openOuterDoor with
     Global => (In_Out => (DoorInner,DoorOuter)),
     Pre => DoorOuter.open_close = closed,
     Post => DoorOuter.open_close = open and DoorInner.open_close = closed
     and DoorOuter.locked_unlocked = unlocked;


   procedure closeOuterDoor with
     Global => (In_Out => DoorOuter),
     Pre => DoorOuter.open_close = Open,
     Post => DoorOuter.open_close = closed
     and DoorOuter.locked_unlocked = locked;

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


   procedure Dive  (A : in Depth) with
     Global => (In_Out => CurrentDepth , Input => maxDepth),
     Pre => CurrentDepth <= maxDepth,
     Post => CurrentDepth <= maxDepth;

  ---- END DIVE CONTROLS ---------------------------------------------------


   ---- WEAPON CONTROLLS ---------------------------------------------------

   procedure loadAllTorpeado (A : in out AmmoStore ; C : in out chambers) with
     Pre => (for some j in A'Range => A(j)  = Loaded) and
     (for some k in C'Range => C(k) = Empty),
     Post => (for some i in C'Range => C(i) = Loaded);

   procedure fireVolley (C : in out chambers) with
     Pre => (for some i in C'Range => C(i) = Loaded),
     Post => (for all j in C'Range => C(j) = Empty);




   --takes chamberes torpeado index and fires it providing its not empty
   procedure fireSingleTorpeado (TI : in Chambered_index; C: in out chambers) with
     Pre => (C(TI) = Loaded),
     Post => (C(TI) = Empty);


   procedure loadChamber (TI : in Chambered_index; C: in out chambers) with
     Pre => (C(TI) = empty),
     Post => (C(TI) = Loaded);

   --- WEAPON CONTROLLS ----------------------------------------------------



end SubMarine;
