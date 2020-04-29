package body Unit_2 is

   task type Boring_Task_Type is
      entry Drop_Off_Work (Work_In : in Range_Type);
   end Boring_Task_Type;

   task body Boring_Task_Type is
      Work   : Range_Type := 5;
      Result : Integer := 0;
      Factor : constant Positive := 2;
   begin
      -- Never ends:
      loop
         accept Drop_Off_Work (Work_In : in Range_Type) do
            Work := Work_In;
         end Drop_Off_Work;
         Result := Integer (Work) * Factor;
      end loop;
   end Boring_Task_Type;

   Boring_Task : Boring_Task_Type;

   procedure You_Do_It (Using : in Range_Type) is
   begin
      if Using = 5 then
         raise Dont_Like_5;
      else
         Boring_Task.Drop_Off_Work (Using);
      end if;
   end You_Do_It;

   -- EXPORTED:
   procedure Do_It (This : in Range_Type) is
   begin
      You_Do_It (Using => This);
   exception
      when X : Dont_Like_5 =>
         null;
   end Do_It;

   -- PRIVATE:
   package body Parent_Class is

   -- EXPORTED:
      procedure Method_1
        (This : in out Object) is
      begin
         This.Component_1 := This.Component_1 * 2;
      end Method_1;

   end Parent_Class;

   -- PRIVATE:
   package body Child_Class is

   -- EXPORTED:
      procedure Method_1
        (This : in out Object) is
      begin
         This.Component_1 := This.Component_1 * 3;
      end Method_1;

   -- EXPORTED:
      function Method_2
        (This    : in out Object;
         Param_1 : in Integer)
         return Integer
      is
         Result : Integer := 0;
      begin
         Result := This.Component_1 + This.Component_2;
         This.Component_2 := Param_1;
         return Result;
      end Method_2;

   end Child_Class;

end Unit_2;
