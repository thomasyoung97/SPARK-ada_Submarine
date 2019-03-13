package SubMarine
with SPARK_Mode
is

   --depth monitor
   type Depth is range 0..1000;
   CurrentDepth : Depth := (Depth'Last / 2);

   --oxegen monitor
   type Oxygen is range 0..100;
   OxygenLevel : Oxygen := Oxygen'Last;
   warningLevel : Oxygen := (Oxygen'Last / 100) * 10;
   EmptyOxygen : Oxygen := Oxygen'First;


   type Torpeado_Store is range 0..50;


   type OpenClose is (Open , closed);
   type lock is (locked, unlocked);

   type door is record
      open_close : OpenClose;
      locked_unlocked : lock;
   end record;


   DoorInner : door := (open_close => closed, locked_unlocked => locked);
   DoorOuter : door := (open_close => closed, locked_unlocked => locked);


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


   procedure CheckOxygen with
     Global => (Input => (OxygenLevel, warningLevel,EmptyOxygen));


   procedure emergancySurface with
     Global => (In_Out => CurrentDepth),
     Pre => CurrentDepth > Depth'First,
     Post => CurrentDepth = Depth'First;

end SubMarine;
