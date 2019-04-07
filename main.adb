with SubMarine;   use SubMarine;
with ada.Text_IO; use ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Strings;
with Ada.Strings;
procedure Main is
   run : Boolean := True;
begin

   Ada.Text_IO.Put ("WELCOME. PERFORMING SYSTEM CHECK");

   New_Line;
   Ada.Text_IO.Put ("...");
   New_Line;
   delay 0.5;
   Ada.Text_IO.Put ("...");
   New_Line;
   delay 0.5;
   Ada.Text_IO.Put ("...");
   New_Line;
   delay 0.5;
   Ada.Text_IO.Put ("...");
   New_Line;
   delay 0.5;
   Ada.Text_IO.Put ("...");
   New_Line;
   delay 0.5;

   Ada.Text_IO.Put ("Current Speed: ");
   Ada.Text_IO.Put (CurrentSpeed'Image);
   Ada.Text_IO.Put (" Knots ");
   New_Line;
   Ada.Text_IO.Put ("Current Depth: ");
   Ada.Text_IO.Put (CurrentDepth'Image);
   Ada.Text_IO.Put (" ft");
   New_Line;
   Ada.Text_IO.Put ("Oxygen Level: ");
   Ada.Text_IO.Put (OxygenLevel'Image);
   Ada.Text_IO.Put (" %");
   New_Line;
   Ada.Text_IO.Put ("Temprature: ");
   Ada.Text_IO.Put (currentTemp'Image);
   Ada.Text_IO.Put (" Degrese");
   New_Line;

   while (run) loop

      New_Line;
      Ada.Text_IO.Put ("Input Command: ");
      declare
         S : String := Ada.Text_IO.Get_Line;
      begin
         if (S = "check oxygen") then

            Ada.Text_IO.Put (OxygenLevel'Image);
            Ada.Text_IO.Put ("%");

         else
            if (S = "check depth") then
               Ada.Text_IO.Put (CurrentDepth'Image);
               Ada.Text_IO.Put (" ft");

            else
               if (S = "check temprature") then
                  Ada.Text_IO.Put (currentTemp'Image);
                  Ada.Text_IO.Put (" Degrese");

               else
                  if (S = "door status") then
                     Ada.Text_IO.Put (DoorOuter.open_close'Image);
                     New_Line;
                     Ada.Text_IO.Put (DoorInner.open_close'Image);

                  else
                     if (S = "check speed") then
                        Ada.Text_IO.Put (CurrentSpeed'Image);
                        Ada.Text_IO.Put (" Knots ");

                     else
                        if (S = "exit") then
                           run := False;

                        else
                           if (S = "Dive") then
                              run := False;

                           else
                              if (S = "set depth") then

                                 declare

                                    A : String := Ada.Text_IO.Get_Line;
                                    B : Depth  := Depth'Value (A);

                                 begin

                                    if
                                      (CurrentDepth + B <= maxDepth and
                                       BothDoorsClosed (DoorOuter, DoorInner))
                                    then

                                       SetDepth (B);

                                       Ada.Text_IO.Put ("Depth Set : ");
                                       Ada.Text_IO.Put (CurrentDepth'Image);
                                       Ada.Text_IO.Put (" ft");

                                    else
                                       Ada.Text_IO.Put
                                         ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                    end if;

                                 end;

                              else
                                 if (S = "Surface") then

                                    if
                                      (CurrentDepth >= Depth'First and
                                       BothDoorsClosed (DoorOuter, DoorInner))
                                    then
                                       Surface;

                                       Ada.Text_IO.Put
                                         ("Surface Complete, Current Depth: ");
                                       Ada.Text_IO.Put (CurrentDepth'Image);
                                    else
                                       Ada.Text_IO.Put
                                         ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                    end if;

                                 else
                                    if (S = "fire torpeado") then

                                       declare

                                          C : String := Ada.Text_IO.Get_Line;
                                          D : Chambered_index :=
                                            Chambered_index'Value (C);

                                       begin

                                          if
                                            ((TChambers (D) = Loaded) and
                                             DoorInner.open_close = closed and
                                             DoorOuter.open_close = closed)
                                          then
                                             fireSingleTorpeado (D, TChambers);

                                             Ada.Text_IO.Put
                                               ("Torpeado Fired : ");

                                             for i in Chambered_index'Range
                                             loop

                                                New_Line;
                                                Ada.Text_IO.Put ("chamber : ");

                                                Ada.Text_IO.Put (i'Image);

                                                Ada.Text_IO.Put
                                                  (TChambers (i)'Image);
                                                New_Line;

                                             end loop;
                                          else
                                             Ada.Text_IO.Put
                                               ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                          end if;
                                       end;

                                    else
                                       if (S = "load torpeado") then

                                          declare

                                             E : String :=
                                               Ada.Text_IO.Get_Line;
                                             F : Chambered_index :=
                                               Chambered_index'Value (E);

                                          begin

                                             if
                                               ((TChambers (F) = Empty) and
                                                (gAmmoStore
                                                   (gAmmoStore'First) =
                                                 Loaded) and
                                                BothDoorsClosed
                                                  (DoorOuter, DoorInner))
                                             then
                                                loadChamber (F, TChambers);

                                                Ada.Text_IO.Put
                                                  ("Torpeado Loaded : ");

                                                for i in Chambered_index'Range
                                                loop

                                                   New_Line;
                                                   Ada.Text_IO.Put
                                                     ("chamber : ");

                                                   Ada.Text_IO.Put (i'Image);

                                                   Ada.Text_IO.Put
                                                     (TChambers (i)'Image);
                                                   New_Line;

                                                end loop;
                                             else
                                                Ada.Text_IO.Put
                                                  ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                             end if;
                                          end;
                                       else
                                          if (S = "check ammo") then

                                             begin

                                                for i in AS_Index'Range loop

                                                   New_Line;
                                                   Ada.Text_IO.Put
                                                     ("Store : ");

                                                   Ada.Text_IO.Put (i'Image);

                                                   Ada.Text_IO.Put
                                                     (gAmmoStore (i)'Image);
                                                   New_Line;

                                                end loop;

                                             end;
                                          else
                                             if (S = "load store") then

                                                begin
                                                   if
                                                     (gAmmoStore
                                                        (gAmmoStore'Last) =
                                                      Empty and
                                                      BothDoorsClosed
                                                        (DoorOuter, DoorInner))
                                                   then
                                                      PUSHAMMO;
                                                      for i in AS_Index'Range
                                                      loop

                                                         New_Line;
                                                         Ada.Text_IO.Put
                                                           ("Store : ");

                                                         Ada.Text_IO.Put
                                                           (i'Image);

                                                         Ada.Text_IO.Put
                                                           (gAmmoStore (i)'
                                                              Image);
                                                         New_Line;

                                                      end loop;
                                                   else
                                                      Ada.Text_IO.Put
                                                        ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                   end if;
                                                end;

                                             else
                                                if (S = "fire volley") then

                                                   begin
                                                      if
                                                        ((for some i in TChambers'
                                                            Range
                                                          =>
                                                            TChambers (i) =
                                                            Loaded) and
                                                         BothDoorsClosed
                                                           (DoorOuter,
                                                            DoorInner))
                                                      then
                                                         fireVolley
                                                           (TChambers);
                                                         for i in Chambered_index'
                                                           Range
                                                         loop

                                                            New_Line;
                                                            Ada.Text_IO.Put
                                                              ("chamber : ");

                                                            Ada.Text_IO.Put
                                                              (i'Image);

                                                            Ada.Text_IO.Put
                                                              (TChambers (i)'
                                                                 Image);
                                                            New_Line;

                                                         end loop;
                                                      else
                                                         Ada.Text_IO.Put
                                                           ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                      end if;
                                                   end;
                                                else
                                                   if (S = "open outer door")
                                                   then

                                                      begin
                                                         if
                                                           (DoorInvairance
                                                              (DoorOuter,
                                                               DoorInner))
                                                         then
                                                            openOuterDoor;
                                                            Ada.Text_IO.Put
                                                              ("Outer Door : ");
                                                            Ada.Text_IO.Put
                                                              (DoorOuter
                                                                 .open_close'
                                                                 Image);
                                                            Ada.Text_IO.Put
                                                              (DoorOuter
                                                                 .locked_unlocked'
                                                                 Image);
                                                            New_Line;
                                                            Ada.Text_IO.Put
                                                              ("Innner Door : ");
                                                            Ada.Text_IO.Put
                                                              (DoorInner
                                                                 .open_close'
                                                                 Image);
                                                         else
                                                            Ada.Text_IO.Put
                                                              ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                         end if;
                                                      end;

                                                   else
                                                      if
                                                        (S = "open inner door")
                                                      then

                                                         begin
                                                            if
                                                              (DoorInvairance
                                                                 (DoorOuter,
                                                                  DoorInner))
                                                            then
                                                               openInnerDoor;

                                                               New_Line;
                                                               Ada.Text_IO.Put
                                                                 ("Innner Door : ");
                                                               Ada.Text_IO.Put
                                                                 (DoorInner
                                                                    .open_close'
                                                                    Image);
                                                               New_Line;
                                                               Ada.Text_IO.Put
                                                                 ("Outer Door : ");
                                                               Ada.Text_IO.Put
                                                                 (DoorOuter
                                                                    .open_close'
                                                                    Image);

                                                            else
                                                               Ada.Text_IO.Put
                                                                 ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                            end if;
                                                         end;
                                                      else
                                                         if
                                                           (S =
                                                            "close inner door")
                                                         then

                                                            begin
                                                               if
                                                                 (DoorInvairance
                                                                    (DoorOuter,
                                                                     DoorInner))
                                                               then
                                                                  closeInnerDoor;

                                                                  New_Line;
                                                                  Ada.Text_IO
                                                                    .Put
                                                                    ("Innner Door : ");
                                                                  Ada.Text_IO
                                                                    .Put
                                                                    (DoorInner
                                                                       .open_close'
                                                                       Image);
                                                                  New_Line;
                                                                  Ada.Text_IO
                                                                    .Put
                                                                    ("Outer Door : ");
                                                                  Ada.Text_IO
                                                                    .Put
                                                                    (DoorOuter
                                                                       .open_close'
                                                                       Image);

                                                               else
                                                                  Ada.Text_IO
                                                                    .Put
                                                                    ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                               end if;
                                                            end;
                                                         else
                                                            if
                                                              (S =
                                                               "close outer door")
                                                            then

                                                               begin
                                                                  if
                                                                    (DoorInvairance
                                                                       (DoorOuter,
                                                                        DoorInner))
                                                                  then
                                                                     closeOuterDoor;

                                                                     New_Line;
                                                                     Ada
                                                                       .Text_IO
                                                                       .Put
                                                                       ("Innner Door : ");
                                                                     Ada
                                                                       .Text_IO
                                                                       .Put
                                                                       (DoorInner
                                                                          .open_close'
                                                                          Image);
                                                                     New_Line;
                                                                     Ada
                                                                       .Text_IO
                                                                       .Put
                                                                       ("Outer Door : ");
                                                                     Ada
                                                                       .Text_IO
                                                                       .Put
                                                                       (DoorOuter
                                                                          .open_close'
                                                                          Image);

                                                                  else
                                                                     Ada
                                                                       .Text_IO
                                                                       .Put
                                                                       ("Pre-Condition Violated - reconsider input, or check both doors are closed");
                                                                  end if;
                                                               end;
                                                            else
                                                               Ada.Text_IO.Put
                                                                 ("INVALID COMMAND");

                                                            end if;
                                                         end if;
                                                      end if;
                                                   end if;
                                                end if;
                                             end if;
                                          end if;
                                       end if;
                                    end if;
                                 end if;
                              end if;
                           end if;
                        end if;
                     end if;
                  end if;
               end if;
            end if;
         end if;
      end;
   end loop;

end Main;
