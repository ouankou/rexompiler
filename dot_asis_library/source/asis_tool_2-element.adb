with Asis.Clauses;
with Asis.Compilation_Units;
with Asis.Declarations;
with Asis.Definitions;
with Asis.Elements;
with Asis.Expressions;
with Asis.Iterator;
with Asis.Statements;
-- GNAT-specific:
with Asis.Set_Get;
with Asis.Text;
with Types;

package body Asis_Tool_2.Element is

   Module_Name : constant String := "Asis_Tool_2.Element";

   procedure Add_Element_List
     (This           : in out Class;
      Elements_In    : in     Asis.Element_List;
      Dot_Label_Name : in     String;
      List_Out       :    out a_nodes_h.Element_List;
      Add_Edges      : in     Boolean := False)
   is
      Element_Count : constant Natural :=
        Elements_In'Length;
      IDs : anhS.Element_ID_Array_Access := new
        anhS.Element_ID_Array (1 .. Element_Count);
      IDs_Index : Positive := IDs'First;
   begin
      for Element of Elements_In loop
         declare
            Element_ID : constant Types.Node_ID :=
              Asis.Set_Get.Node_Value (Element);
            Label : constant String :=
              Dot_Label_Name & " (" & IDs_Index'Image & ")";
         begin
            IDs (IDs_Index) := Interfaces.C.int (Element_ID);
            This.Add_To_Dot_Label (Label, To_String (Element_ID));
            if Add_Edges then
               This.Add_Dot_Edge (From  => This.Element_ID,
                                  To    => Element_ID,
                                  Label => Label);
            end if;
            IDs_Index := IDs_Index + 1;
         end;
      end loop;
      List_Out :=
        (length => Interfaces.C.int(Element_Count),
         IDs    => anhS.To_Element_ID_Ptr (IDs));
   end Add_Element_List;

   function Add_Operator_Kind
     (State   : in out Class;
      Element : in     Asis.Element)
      return a_nodes_h.Operator_Kinds
   is
      Operator_Kind : constant Asis.Operator_Kinds :=
        Asis.Elements.Operator_Kind (Element);
   begin
      State.Add_To_Dot_Label ("Operator_Kind", Operator_Kind'Image);
      return anhS.To_Operator_Kinds (Operator_Kind);
   end;

   package Pre_Children is

      procedure Process_Element
        (Element : in     Asis.Element;
         Control : in out Asis.Traverse_Control;
         State   : in out Class);

   end Pre_Children;

   package body Pre_Children is
      Parent_Name : constant String := Module_Name;
      Module_Name : constant String := Parent_Name & ".Pre_Children";

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Pragma
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Pragma";
         Pragma_Kind : Asis.Pragma_Kinds :=
           Asis.Elements.Pragma_Kind (Element);
      begin
         --        A_Pragma              -> Pragma_Kinds
         --
         State.Add_To_Dot_Label
           (Name => "Pragma_Kind",
            Value => Pragma_Kind'Image);
         State.Add_Not_Implemented;
      end Process_Pragma;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Defining_Name
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Defining_Name";
         Result : a_nodes_h.Defining_Name_Struct :=
           a_nodes_h.Support.Default_Defining_Name_Struct;

         Defining_Name_Kind : Asis.Defining_Name_Kinds :=
           Asis.Elements.Defining_Name_Kind (Element);

         -- Supporting procedures are in alphabetical order:
         procedure Add_Defining_Name_Image is
            WS : constant Wide_String := Asis.Declarations.Defining_Name_Image (Element);
         begin
            State.Add_To_Dot_Label ("Defining_Name_Image", To_Quoted_String (WS));
            Result.Defining_Name_Image := To_Chars_Ptr(WS);
         end;

         procedure Add_Defining_Prefix is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Defining_Prefix (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Defining_Prefix", ID);
            Result.Defining_Prefix := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Defining_Selector is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Defining_Selector (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Defining_Selector", ID);
            Result.Defining_Selector := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Position_Number_Image is
            WS : constant Wide_String := Asis.Declarations.Position_Number_Image (Element);
         begin
            State.Add_To_Dot_Label ("Position_Number_Image", To_String (WS));
            Result.Position_Number_Image := To_Chars_Ptr(WS);
         end;

         procedure Add_Representation_Value_Image is
            WS : constant Wide_String := Asis.Declarations.Representation_Value_Image (Element);
         begin
            State.Add_To_Dot_Label ("Representation_Value_Image", To_String (WS));
            Result.Representation_Value_Image := To_Chars_Ptr(WS);
         end;

         -- True if this is the name of a constant or a deferred constant.
         -- TODO: Implement
         function Is_Constant return Boolean is
           (False);

         procedure Add_Corresponding_Constant_Declaration is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node
                (Asis.Declarations.Corresponding_Constant_Declaration (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Constant_Declaration", To_String(ID));
            Result.Corresponding_Constant_Declaration := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label
              (Name => "Defining_Name_Kind", Value => Defining_Name_Kind'Image);
            Result.Defining_Name_Kind :=
              anhS.To_Defining_Name_Kinds (Defining_Name_Kind);
            Add_Defining_Name_Image;
         end Add_Common_Items;

         use all type Asis.Defining_Name_Kinds;
      begin
         If Defining_Name_Kind = Not_A_Defining_Name then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Defining_Name_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Defining_Name_Kind is
            when Not_A_Defining_Name =>
               raise Program_Error with
               Module_Name & " called with: " & Defining_Name_Kind'Image;

            when A_Defining_Identifier =>
               null; -- No more info

            when A_Defining_Character_Literal |
                 A_Defining_Enumeration_Literal =>
               Add_Position_Number_Image;
               Add_Representation_Value_Image;

            when A_Defining_Operator_Symbol =>
               Result.Operator_Kind := Add_Operator_Kind (State, Element);

            when A_Defining_Expanded_Name =>
               Add_Defining_Prefix;
               Add_Defining_Selector;
         end case;

         if Is_Constant then
            Add_Corresponding_Constant_Declaration;
         end if;

         State.A_Element.Element_Kind := a_nodes_h.A_Defining_Name;
         State.A_Element.The_Union.Defining_Name := Result;
      end Process_Defining_Name;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Declaration
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Declaration";
         Result : a_nodes_h.Declaration_Struct :=
           a_nodes_h.Support.Default_Declaration_Struct;

         Declaration_Kind : Asis.Declaration_Kinds :=
           Asis.Elements.Declaration_Kind (Element);

         -- Supporting procedures are in alphabetical order:
         procedure Add_Aspect_Specifications is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Aspect_Specifications (Element),
               Dot_Label_Name => "Aspect_Specifications",
               List_Out       => Result.Aspect_Specifications,
               Add_Edges      => True);
         end;

         procedure Add_Body_Block_Statement is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Body_Block_Statement (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Body_Block_Statement", ID);
            Result.Body_Block_Statement := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Body_Declarative_Items is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Body_Declarative_Items (Element),
               Dot_Label_Name => "Body_Declarative_Items",
               List_Out       => Result.Body_Declarative_Items,
               Add_Edges      => True);
         end;

         procedure Add_Body_Exception_Handlers is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Body_Exception_Handlers (Element),
               Dot_Label_Name => "Body_Exception_Handlers",
               List_Out       => Result.Body_Exception_Handlers,
               Add_Edges      => True);
         end;

         procedure Add_Body_Statements is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Body_Statements (Element),
               Dot_Label_Name => "Body_Statements",
               List_Out       => Result.Body_Statements,
               Add_Edges      => True);
         end;

         procedure Add_Corresponding_Body is
--              ID : constant Types.Node_Id :=
--                Asis.Set_Get.Node (Asis.Declarations.Corresponding_Body (Element));
         begin
            -- Todo: Finish
            null;
--              State.Add_To_Dot_Label ("Corresponding_Body", ID);
--              Result.Corresponding_Body := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Body_Stub is
--              ID : constant Types.Node_Id :=
--                Asis.Set_Get.Node (Asis.Declarations.Corresponding_Body_Stub (Element));
         begin
            -- Todo: Finish
            null;
--              State.Add_To_Dot_Label ("Corresponding_Body_Stub", ID);
--              Result.Corresponding_Body_Stub := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Declaration is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Declaration (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Declaration", ID);
            Result.Corresponding_Declaration := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_End_Name is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Elements.Corresponding_End_Name (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_End_Name", ID);
            Result.Corresponding_End_Name := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Equality_Operator is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Equality_Operator (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Equality_Operator", ID);
            Result.Corresponding_Equality_Operator := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_First_Subtype is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_First_Subtype (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_First_Subtype", ID);
            Result.Corresponding_First_Subtype := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Last_Constraint is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Last_Constraint (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Last_Constraint", ID);
            Result.Corresponding_Last_Constraint := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Last_Subtype is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Last_Subtype (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Last_Subtype", ID);
            Result.Corresponding_Last_Subtype := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Pragmas is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Elements.Corresponding_Pragmas (Element),
               Dot_Label_Name => "Corresponding_Pragmas",
               List_Out       => Result.Corresponding_Pragmas,
               Add_Edges      => True);
         end;

         procedure Add_Corresponding_Representation_Clauses is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Corresponding_Representation_Clauses (Element),
               Dot_Label_Name => "Corresponding_Representation_Clauses",
               List_Out       => Result.Corresponding_Representation_Clauses);
         end;

         procedure Add_Corresponding_Subprogram_Derivation is
--              ID : constant Types.Node_Id :=
--                Asis.Set_Get.Node (Asis.Declarations.Corresponding_Subprogram_Derivation (Element));
         begin
            -- TODO: Finish
            null;
--              State.Add_To_Dot_Label ("Corresponding_Subprogram_Derivation", ID);
--              Result.Corresponding_Subprogram_Derivation := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Type is
--              ID : constant Types.Node_Id :=
--                Asis.Set_Get.Node (Asis.Declarations.Corresponding_Type (Element));
         begin
            -- TODO: Finish
            null;
--              State.Add_To_Dot_Label ("Corresponding_Type", ID);
--              Result.Corresponding_Type := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Type_Declaration is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Type_Declaration (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Type_Declaration", ID);
            Result.Corresponding_Type_Declaration := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Type_Partial_View is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Corresponding_Type_Partial_View (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Type_Partial_View", ID);
            Result.Corresponding_Type_Partial_View := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Declaration_Interface_List is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Declaration_Interface_List (Element),
               Dot_Label_Name => "Declaration_Interface_List",
               List_Out       => Result.Declaration_Interface_List,
               Add_Edges      => True);
         end;

         procedure Add_Declaration_Kind is
            -- Hides same thing in outer scope:
            Value : Asis.Declaration_Kinds :=  Asis.Elements.Declaration_Kind (Element);
         begin
            State.Add_To_Dot_Label ("Declaration_Kind", Value'Image);
            Result.Declaration_Kind :=
              a_nodes_h.Support.To_Declaration_Kinds (Value);
         end;

         procedure Add_Declaration_Origin is
            Value : Asis.Declaration_Origins :=  Asis.Elements.Declaration_Origin (Element);
         begin
            State.Add_To_Dot_Label ("Declaration_Origin", Value'Image);
            Result.Declaration_Origin :=
              a_nodes_h.Support.To_Declaration_Origins (Value);
         end;

         procedure Add_Discriminant_Part is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Discriminant_Part (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Discriminant_Part", ID);
            Result.Discriminant_Part := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Entry_Family_Definition is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Entry_Family_Definition (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Entry_Family_Definition", ID);
            Result.Entry_Family_Definition := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Entry_Index_Specification is
--              ID : constant Types.Node_Id :=
--                Asis.Set_Get.Node (Asis.Declarations.Entry_Index_Specification (Element));
         begin
            -- TODO: Finish
            null;
--              State.Add_To_Dot_Label_And_Edge ("Entry_Index_Specification", ID);
--              Result.Entry_Index_Specification := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Has_Abstract is
            Value : constant Boolean := Asis.Elements.Has_Abstract (Element);
         begin
            State.Add_To_Dot_Label ("Has_Abstract", Value'Image);
            Result.Has_Abstract := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Aliased is
            Value : constant Boolean := Asis.Elements.Has_Aliased (Element);
         begin
            State.Add_To_Dot_Label ("Has_Aliased", Value'Image);
            Result.Has_Aliased := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Limited is
            Value : constant Boolean := Asis.Elements.Has_Limited (Element);
         begin
            State.Add_To_Dot_Label ("Has_Limited", Value'Image);
            Result.Has_Limited := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Null_Exclusion is
            Value : constant Boolean := Asis.Elements.Has_Null_Exclusion (Element);
         begin
            State.Add_To_Dot_Label ("Has_Null_Exclusion", Value'Image);
            Result.Has_Null_Exclusion := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Private is
            Value : constant Boolean := Asis.Elements.Has_Private (Element);
         begin
            State.Add_To_Dot_Label ("Has_Private", Value'Image);
            Result.Has_Private := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Protected is
            Value : constant Boolean := Asis.Elements.Has_Protected (Element);
         begin
            State.Add_To_Dot_Label ("Has_Protected", Value'Image);
            Result.Has_Protected := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Reverse is
            Value : constant Boolean := Asis.Elements.Has_Reverse (Element);
         begin
            State.Add_To_Dot_Label ("Has_Reverse", Value'Image);
            Result.Has_Reverse := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Has_Task is
            Value : constant Boolean := Asis.Elements.Has_Task (Element);
         begin
            State.Add_To_Dot_Label ("Has_Task", Value'Image);
            Result.Has_Task := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Initialization_Expression is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Initialization_Expression (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Initialization_Expression", ID);
            Result.Initialization_Expression := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Is_Dispatching_Operation is
            Value : constant Boolean := Asis.Declarations.Is_Dispatching_Operation (Element);
         begin
            State.Add_To_Dot_Label ("Is_Dispatching_Operation", Value'Image);
            Result.Is_Dispatching_Operation := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Name_Repeated is
            Value : constant Boolean := Asis.Declarations.Is_Name_Repeated (Element);
         begin
            State.Add_To_Dot_Label ("Is_Name_Repeated", Value'Image);
            Result.Is_Name_Repeated := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Not_Null_Return is
            Value : constant Boolean := Asis.Elements.Is_Not_Null_Return (Element);
         begin
            State.Add_To_Dot_Label ("Is_Not_Null_Return", Value'Image);
            Result.Is_Not_Null_Return := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Not_Overriding_Declaration is
            Value : constant Boolean := Asis.Declarations.Is_Not_Overriding_Declaration (Element);
         begin
            State.Add_To_Dot_Label ("Is_Not_Overriding_Declaration", Value'Image);
            Result.Is_Not_Overriding_Declaration := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Overriding_Declaration is
            Value : constant Boolean := Asis.Declarations.Is_Overriding_Declaration (Element);
         begin
            State.Add_To_Dot_Label ("Is_Overriding_Declaration", Value'Image);
            Result.Is_Overriding_Declaration := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Private_Present is
            Value : constant Boolean := Asis.Declarations.Is_Private_Present (Element);
         begin
            State.Add_To_Dot_Label ("Is_Private_Present", Value'Image);
            Result.Is_Private_Present := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Subunit is
            Value : constant Boolean := Asis.Declarations.Is_Subunit (Element);
         begin
            State.Add_To_Dot_Label ("Is_Subunit", Value'Image);
            Result.Is_Subunit := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Mode_Kind is
            Value : constant Asis.Mode_Kinds :=  Asis.Elements.Mode_Kind (Element);
         begin
            State.Add_To_Dot_Label ("Mode_Kind", Value'Image);
            Result.Mode_Kind := a_nodes_h.Support.To_Mode_Kinds (Value);
         end;

         procedure Add_Names is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Names (Element),
               Dot_Label_Name => "Names",
               List_Out       => Result.Names,
               Add_Edges      => True);
         end;

         procedure Add_Object_Declaration_View is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Object_Declaration_View (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Object_Declaration_View", ID);
            Result.Object_Declaration_View := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Parameter_Profile is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Parameter_Profile (Element),
               Dot_Label_Name => "Parameter_Profile",
               List_Out       => Result.Parameter_Profile,
               Add_Edges      => True);
         end;

         procedure Add_Pragmas is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Elements.Pragmas (Element),
               Dot_Label_Name => "Pragmas",
               List_Out       => Result.Pragmas,
               Add_Edges      => True);
         end;

         procedure Add_Private_Part_Declarative_Items is begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Private_Part_Declarative_Items (Element),
               Dot_Label_Name => "Private_Part_Declarative_Items",
               List_Out       => Result.Private_Part_Declarative_Items,
               Add_Edges      => True);
         end;

         procedure Add_Result_Profile is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Result_Profile (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Result_Profile", ID);
            Result.Result_Profile := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Type_Declaration_View is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Declarations.Type_Declaration_View (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Type_Declaration_View", ID);
            Result.Type_Declaration_View := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Visible_Part_Declarative_Items is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Declarations.Visible_Part_Declarative_Items (Element),
               Dot_Label_Name => "Visible_Part_Declarative_Items",
               List_Out       => Result.Visible_Part_Declarative_Items,
               Add_Edges      => True);
         end;

         procedure Add_Common_Items is
         begin
            Add_Declaration_Kind;
            Add_Declaration_Origin;
            Add_Corresponding_Pragmas;
            Add_Names;
            Add_Aspect_Specifications;
            Add_Corresponding_Representation_Clauses;
         end Add_Common_Items;

         use all type Asis.Declaration_Kinds;
      begin -- Process_Declaration
         If Declaration_Kind = Not_A_Declaration then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Declaration_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Declaration_Kind is
            when Not_A_Declaration =>
               raise Program_Error with
                 Module_Name & " called with: " & Declaration_Kind'Image;

            when An_Ordinary_Type_Declaration =>
               Add_Has_Abstract;
               Add_Has_Limited;
               Add_Discriminant_Part;
               Add_Type_Declaration_View;
               Add_Corresponding_Type_Declaration;
               Add_Corresponding_Type_Partial_View;
               Add_Corresponding_First_Subtype;
               Add_Corresponding_Last_Constraint;
               Add_Corresponding_Last_Subtype;

            when A_Task_Type_Declaration =>
               Add_Has_Task;
               Add_Corresponding_End_Name;
               Add_Discriminant_Part;
               Add_Type_Declaration_View;
               Add_Corresponding_Type_Declaration;
               Add_Corresponding_Type_Partial_View;
               Add_Corresponding_First_Subtype;
               Add_Corresponding_Last_Constraint;
               Add_Corresponding_Last_Subtype;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Corresponding_Body;
               Add_Declaration_Interface_List;

            when A_Protected_Type_Declaration =>
               Add_Has_Protected;
               Add_Corresponding_End_Name;
               Add_Discriminant_Part;
               Add_Type_Declaration_View;
               Add_Corresponding_Type_Declaration;
               Add_Corresponding_Type_Partial_View;
               Add_Corresponding_First_Subtype;
               Add_Corresponding_Last_Constraint;
               Add_Corresponding_Last_Subtype;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Corresponding_Body;
               Add_Declaration_Interface_List;

            when An_Incomplete_Type_Declaration =>
               State.Add_Not_Implemented;

            when A_Tagged_Incomplete_Type_Declaration =>
               State.Add_Not_Implemented;

            when A_Private_Type_Declaration =>
               State.Add_Not_Implemented;

            when A_Private_Extension_Declaration =>
               State.Add_Not_Implemented;

            when A_Subtype_Declaration =>
               State.Add_Not_Implemented;

            when A_Variable_Declaration =>
               Add_Object_Declaration_View;
               Add_Initialization_Expression;

            when A_Constant_Declaration =>
               Add_Object_Declaration_View;
               Add_Initialization_Expression;

            when A_Deferred_Constant_Declaration =>
               State.Add_Not_Implemented;

            when A_Single_Task_Declaration =>
               State.Add_Not_Implemented;

            when A_Single_Protected_Declaration =>
               State.Add_Not_Implemented;

            when An_Integer_Number_Declaration =>
               State.Add_Not_Implemented;

            when A_Real_Number_Declaration =>
               State.Add_Not_Implemented;

            when An_Enumeration_Literal_Specification =>
               State.Add_Not_Implemented;

            when A_Discriminant_Specification =>
               State.Add_Not_Implemented;

            when A_Component_Declaration =>
               Add_Object_Declaration_View;
               Add_Initialization_Expression;

            when A_Loop_Parameter_Specification =>
               State.Add_Not_Implemented;

            when A_Generalized_Iterator_Specification =>
               State.Add_Not_Implemented;

            when An_Element_Iterator_Specification =>
               State.Add_Not_Implemented;

            when A_Procedure_Declaration =>
               Add_Has_Abstract;
               Add_Is_Not_Null_Return;
               Add_Parameter_Profile;
               Add_Is_Overriding_Declaration;
               Add_Is_Not_Overriding_Declaration;
               Add_Corresponding_Declaration;
               Add_Corresponding_Body;
               Add_Corresponding_Subprogram_Derivation;
               Add_Corresponding_Type;
               Add_Is_Dispatching_Operation;

            when A_Function_Declaration =>
               Add_Has_Abstract;
               Add_Parameter_Profile;
               Add_Result_Profile;
               Add_Is_Overriding_Declaration;
               Add_Is_Not_Overriding_Declaration;
               Add_Corresponding_Declaration;
               Add_Corresponding_Body;
               Add_Corresponding_Subprogram_Derivation;
               Add_Corresponding_Type;
               Add_Corresponding_Equality_Operator;
               Add_Is_Dispatching_Operation;

            when A_Parameter_Specification =>
               Add_Has_Aliased;
               Add_Has_Null_Exclusion;
               Add_Mode_Kind;
               Add_Object_Declaration_View;
               Add_Initialization_Expression;

            when A_Procedure_Body_Declaration =>
               Add_Pragmas;
               Add_Corresponding_End_Name;
               Add_Parameter_Profile;
               Add_Is_Overriding_Declaration;
               Add_Is_Not_Overriding_Declaration;
               Add_Body_Declarative_Items;
               Add_Body_Statements;
               Add_Body_Exception_Handlers;
               Add_Body_Block_Statement;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Is_Subunit;
               Add_Corresponding_Body_Stub;
               Add_Is_Dispatching_Operation;

            when A_Function_Body_Declaration =>
               Add_Is_Not_Null_Return;
               Add_Pragmas;
               Add_Corresponding_End_Name;
               Add_Parameter_Profile;
               Add_Result_Profile;
               Add_Is_Overriding_Declaration;
               Add_Is_Not_Overriding_Declaration;
               Add_Body_Declarative_Items;
               Add_Body_Statements;
               Add_Body_Exception_Handlers;
               Add_Body_Block_Statement;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Is_Subunit;
               Add_Corresponding_Body_Stub;
               Add_Is_Dispatching_Operation;

            when A_Return_Variable_Specification =>
               State.Add_Not_Implemented;

            when A_Return_Constant_Specification =>
               State.Add_Not_Implemented;

            when A_Null_Procedure_Declaration =>
               State.Add_Not_Implemented;

            when An_Expression_Function_Declaration =>
               State.Add_Not_Implemented;

            when A_Package_Declaration =>
               Add_Pragmas;
               Add_Corresponding_End_Name;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Corresponding_Body;
               Add_Visible_Part_Declarative_Items;
               Add_Is_Private_Present;
               Add_Private_Part_Declarative_Items;

            when A_Package_Body_Declaration =>
               Add_Pragmas;
               Add_Corresponding_End_Name;
               Add_Body_Declarative_Items;
               Add_Body_Statements;
               Add_Body_Exception_Handlers;
               Add_Body_Block_Statement;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Is_Subunit;
               Add_Corresponding_Body_Stub;

            when An_Object_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when An_Exception_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Package_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Procedure_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Function_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Generic_Package_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Generic_Procedure_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Generic_Function_Renaming_Declaration =>
               State.Add_Not_Implemented;

            when A_Task_Body_Declaration =>
               Add_Has_Task;
               Add_Pragmas;
               Add_Corresponding_End_Name;
               Add_Body_Declarative_Items;
               Add_Body_Statements;
               Add_Body_Exception_Handlers;
               Add_Body_Block_Statement;
               Add_Is_Name_Repeated;
               Add_Corresponding_Declaration;
               Add_Is_Subunit;
               Add_Corresponding_Body_Stub;

            when A_Protected_Body_Declaration =>
               State.Add_Not_Implemented;

            when An_Entry_Declaration =>
               Add_Parameter_Profile;
               Add_Is_Overriding_Declaration;
               Add_Is_Not_Overriding_Declaration;
               Add_Corresponding_Body;
               Add_Entry_Family_Definition;

            when An_Entry_Body_Declaration =>
               State.Add_Not_Implemented;

            when An_Entry_Index_Specification =>
               State.Add_Not_Implemented;

            when A_Procedure_Body_Stub =>
               State.Add_Not_Implemented;

            when A_Function_Body_Stub =>
               State.Add_Not_Implemented;

            when A_Package_Body_Stub =>
               State.Add_Not_Implemented;

            when A_Task_Body_Stub =>
               State.Add_Not_Implemented;

            when A_Protected_Body_Stub =>
               State.Add_Not_Implemented;

            when An_Exception_Declaration =>
               null; -- No more info

            when A_Choice_Parameter_Specification =>
               null; -- No more info

            when A_Generic_Procedure_Declaration =>
               State.Add_Not_Implemented;

            when A_Generic_Function_Declaration =>
               State.Add_Not_Implemented;

            when A_Generic_Package_Declaration =>
               State.Add_Not_Implemented;

            when A_Package_Instantiation =>
               State.Add_Not_Implemented;

            when A_Procedure_Instantiation =>
               State.Add_Not_Implemented;

            when A_Function_Instantiation =>
               State.Add_Not_Implemented;

            when A_Formal_Object_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Type_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Incomplete_Type_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Procedure_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Function_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Package_Declaration =>
               State.Add_Not_Implemented;

            when A_Formal_Package_Declaration_With_Box =>
               State.Add_Not_Implemented;
         end case;

         State.A_Element.Element_Kind := a_nodes_h.A_Declaration;
         State.A_Element.The_Union.Declaration := Result;
      end Process_Declaration;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Definition
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Definition";

         Result          : a_nodes_h.Definition_Struct :=
           a_nodes_h.Support.Default_Definition_Struct;
         Definition_Kind : constant Asis.Definition_Kinds :=
           Asis.Elements.Definition_Kind (Element);

         procedure hide_me is

            procedure Add_Component_Definition_View is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Component_Definition_View (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Component_Definition_View", ID);
               Result.Component_Definition_View := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Implicit_Components is
               -- Not implemented in ASIS for GNAT GPL 2017 (20170515-63)GNAT GPL 2017 (20170515-63):
               Implemented_In_Asis : constant Boolean := False;
            begin
               if Implemented_In_Asis then
                  Add_Element_List
                    (This           => State,
                     Elements_In    => Asis.Definitions.Implicit_Components (Element),
                     Dot_Label_Name => "Implicit_Components",
                     List_Out       => Result.Implicit_Components);
               end if;
            end;

            procedure Add_Is_Private_Present is
               Value : constant Boolean := Asis.Definitions.Is_Private_Present (Element);
            begin
               State.Add_To_Dot_Label ("Is_Private_Present", Value'Image);
               Result.Is_Private_Present := a_nodes_h.Support.To_bool (Value);
            end;

            procedure Add_Private_Part_Items is
            begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Private_Part_Items (Element),
                  Dot_Label_Name => "Private_Part_Items",
                  List_Out       => Result.Private_Part_Items,
                  Add_Edges      => True);
            end;

            procedure Add_Subtype_Constraint is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Subtype_Constraint (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Subtype_Constraint", ID);
               Result.Subtype_Constraint := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Record_Components is
            begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Record_Components (Element),
                  Dot_Label_Name => "Record_Components",
                  List_Out       => Result.Record_Components,
                  Add_Edges      => True);
            end;

            procedure Add_Visible_Part_Items is
            begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Visible_Part_Items (Element),
                  Dot_Label_Name => "Visible_Part_Items",
                  List_Out       => Result.Visible_Part_Items,
                  Add_Edges      => True);
            end;

         begin
            null;
         end hide_me;

         -- Has side-effects:
         function Get_Has_Null_Exclusion return ICE.bool is
            Value : constant Boolean := Asis.Elements.Has_Null_Exclusion (Element);
         begin
            State.Add_To_Dot_Label ("Has_Null_Exclusion", Value'Image);
            return a_nodes_h.Support.To_bool (Value);
         end Get_Has_Null_Exclusion;

         -- Has side-effects:
         function Get_Subtype_Mark return a_nodes_h.Node_ID is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Definitions.Subtype_Mark (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Subtype_Mark", ID);
            return a_nodes_h.Node_ID (ID);
         end Get_Subtype_Mark;

         -- Has side-effects:
         function Get_Subtype_Constraint return a_nodes_h.Constraint_Struct is
            Parent_Name : constant String := Module_Name;
            Module_Name : constant String := Parent_Name & ".Get_Subtype_Constraint";

            Result          : a_nodes_h.Constraint_Struct :=
              a_nodes_h.Support.Default_Constraint_Struct;
            Constraint_Kind : constant Asis.Constraint_Kinds :=
              Asis.Elements.Constraint_Kind (Element);

            procedure Add_Common_Items is
            begin
               Add_Constraint_Kind;
            end Add_Common_Items;

            use all type Asis.Constraint_Kinds;
         begin
            If Constraint_Kind = Not_A_Constraint then
               -- Redundant with the case below, but lets this if be clearer:
               raise Program_Error with
               Module_Name & " called with: " & Constraint_Kind'Image;
            else
               Add_Common_Items;
            end if;

            case Constraint_Kind is
               when Not_A_Constraint =>
                  raise Program_Error with
                  Module_Name &   " called with: " & Constraint_Kind'Image;
               when A_Range_Attribute_Reference =>
                  Add_Range_Attribute;
               when A_Simple_Expression_Range =>
                  Add_Lower_Bound;
                  Add_Upper_Bound;
               when A_Digits_Constraint =>
                  Add_Digits_Expression;
                  Add_Real_Range_Constraint;
               when A_Delta_Constraint =>
                  Add_Delta_Expresssion;
                  Add_Real_Range_Constraint;
               when An_Index_Constraint =>
                  Add_Discrete_Ranges;
               when A_Discriminant_Constraint =>
                  Add_Discriminant_Associations;
            end case;

            return Result;
         end Get_Subtype_Constraint;

         -----------------------------------------------------------------------

         -- Has side effects:
         function Get_Type_Definition
           return a_nodes_h.Type_Definition_Struct
         is
            Parent_Name : constant String := Module_Name;
            Module_Name : constant String := Parent_Name & ".Process_Type_Definition";

            Result    : a_nodes_h.Type_Definition_Struct :=
              a_nodes_h.Support.Default_Type_Definition_Struct;
            Type_Kind : constant Asis.Type_Kinds :=
              Asis.Elements.Type_Kind (Element);

            procedure Add_Parent_Subtype_Indication is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Parent_Subtype_Indication
                                    (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Parent_Subtype_Indication", ID);
               Result.Parent_Subtype_Indication := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Record_Definition is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Record_Definition (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Record_Definition", ID);
               Result.Record_Definition := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Implicit_Inherited_Declarations is
            begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Implicit_Inherited_Declarations (Element),
                  Dot_Label_Name => "Implicit_Inherited_Declarations",
                  List_Out       => Result.Implicit_Inherited_Declarations);
            end;

            procedure Add_Implicit_Inherited_Subprograms is
            begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Implicit_Inherited_Subprograms (Element),
                  Dot_Label_Name => "Implicit_Inherited_Subprograms",
                  List_Out       => Result.Implicit_Inherited_Subprograms);
            end;

            procedure Add_Corresponding_Parent_Subtype is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Corresponding_Parent_Subtype
                                    (Element));
            begin
               State.Add_To_Dot_Label ("Corresponding_Parent_Subtype", To_String (ID));
               Result.Corresponding_Parent_Subtype := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Corresponding_Root_Type is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Corresponding_Root_Type
                                    (Element));
            begin
               State.Add_To_Dot_Label ("Corresponding_Root_Type", To_String (ID));
               Result.Corresponding_Root_Type := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Corresponding_Type_Structure is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Corresponding_Type_Structure
                                    (Element));
            begin
               State.Add_To_Dot_Label ("Corresponding_Type_Structure", To_String (ID));
               Result.Corresponding_Type_Structure := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Common_Items is
            begin
               State.Add_To_Dot_Label ("Type_Kind", Type_Kind'Image);
               Result.Type_Kind := anhS.To_Type_Kinds (Type_Kind);
               Add_Has_Abstract;
               Add_Has_Limited;
               Add_Has_Private;
               Add_Corresponding_Type_Operators;
            end Add_Common_Items;

            use all type Asis.Type_Kinds;
         begin -- Process_Type_Definition
            If Type_Kind = Not_A_Type_Definition then
               -- Redundant with the case below, but lets this if be clearer:
               raise Program_Error with
               Module_Name & " called with: " & Type_Kind'Image;
            else
               Add_Common_Items;
            end if;

            case Type_Kind is
               when Not_A_Type_Definition =>
                  raise Program_Error with
                  Module_Name & " called with: " & Type_Kind'Image;
               when A_Derived_Type_Definition =>
                  Add_Parent_Subtype_Indication;
                  Add_Implicit_Inherited_Declarations;
                  Add_Implicit_Inherited_Subprograms;
                  Add_Corresponding_Parent_Subtype;
                  Add_Corresponding_Root_Type;
                  Add_Corresponding_Type_Structure;
               when A_Derived_Record_Extension_Definition =>
                  Add_Parent_Subtype_Indication;
                  Add_Record_Definition;
                  Add_Implicit_Inherited_Declarations;
                  Add_Implicit_Inherited_Subprograms;
                  Add_Corresponding_Parent_Subtype;
                  Add_Corresponding_Root_Type;
                  Add_Corresponding_Type_Structure;
                  Add_Definition_Interface_List;
               when An_Enumeration_Type_Definition |
                    A_Signed_Integer_Type_Definition |
                    A_Modular_Type_Definition |
                    A_Root_Type_Definition |
                    A_Floating_Point_Definition |
                    An_Ordinary_Fixed_Point_Definition |
                    A_Decimal_Fixed_Point_Definition |
                    An_Unconstrained_Array_Definition |
                    A_Constrained_Array_Definition =>
                  State.Add_Not_Implemented;
               when A_Record_Type_Definition =>
                  Add_Has_Tagged; -- Small x in spreadsheet?
                  Add_Record_Definition;
               when A_Tagged_Record_Type_Definition =>
                  Add_Record_Definition;
               when An_Interface_Type_Definition =>
                  State.Add_Not_Implemented;
               when An_Access_Type_Definition =>
                  Result.Has_Null_Exclusion := Get_Has_Null_Exclusion;
                  State.Add_Not_Implemented;
            end case;

            return Result;
         end Get_Type_Definition;

         -----------------------------------------------------------------------

         -- Has side effects:
         function Get_Subtype_Indication
           return a_nodes_h.Subtype_Indication_Struct
         is
            Result : a_nodes_h.Subtype_Indication_Struct :=
              a_nodes_h.Support.Default_Subtype_Indication_Struct;
         begin -- Process_Subtype_Indication
            Result.Has_Null_Exclusion := Get_Has_Null_Exclusion;
            Result.Subtype_Mark       := Get_Subtype_Mark;
            Result.Subtype_Constraint := Get_Subtype_Constraint;
            return Result;
         end Get_Subtype_Indication;

         -----------------------------------------------------------------------

         -- Has side effects:
         function Get_Constraint
           return a_nodes_h.Constraint_Struct
         is
            Parent_Name : constant String := Module_Name;
            Module_Name : constant String := Parent_Name & ".Process_Constraint";
            Result : a_nodes_h.Constraint_Struct :=
              a_nodes_h.Support.Default_Constraint_Struct;

            Constraint_Kind : constant Asis.Constraint_Kinds :=
              Asis.Elements.Constraint_Kind (Element);

            procedure Add_Digits_Expression is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Delta_Expression is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Real_Range_Constraint is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Lower_Bound is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Lower_Bound (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Lower_Bound", ID);
               Result.Lower_Bound := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Upper_Bound is
               ID : constant Types.Node_Id :=
                 Asis.Set_Get.Node (Asis.Definitions.Upper_Bound (Element));
            begin
               State.Add_To_Dot_Label_And_Edge ("Upper_Bound", ID);
               Result.Upper_Bound := a_nodes_h.Node_ID (ID);
            end;

            procedure Add_Range_Attribute is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Discrete_Ranges is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Discriminant_Associations is
            begin
               State.Add_Not_Implemented;
            end;

            procedure Add_Common_Items is
            begin
               State.Add_To_Dot_Label ("Constraint_Kind", Constraint_Kind'Image);
               Result.Constraint_Kind := anhS.To_Constraint_Kinds (Constraint_Kind);
            end Add_Common_Items;

            use all type Asis.Constraint_Kinds;
         begin -- Process_Constraint
            if Constraint_Kind = Not_A_Constraint then
               -- Redundant with the case below, but lets this if be clearer:
               raise Program_Error with
               Module_Name & " called with: " & Constraint_Kind'Image;
            else
               Add_Common_Items;
            end if;

            case Constraint_Kind is
               when Not_A_Constraint =>
                  raise Program_Error with
                    "Element.Pre_Children.Process_Definition.Process_Constraint called with: " &
                    Constraint_Kind'Image;
               when A_Range_Attribute_Reference =>
                  Add_Range_Attribute;
               when A_Simple_Expression_Range =>
                  Add_Lower_Bound;
                  Add_Upper_Bound;
               when A_Digits_Constraint =>
                  Add_Digits_Expression;
                  Add_Real_Range_Constraint;
               when A_Delta_Constraint =>
                  Add_Delta_Expression;
                  Add_Real_Range_Constraint;
               when An_Index_Constraint =>
                  Add_Discrete_Ranges;
               when A_Discriminant_Constraint =>
                  Add_Discriminant_Associations;
            end case;

            return Result;
         end Get_Constraint;

         -----------------------------------------------------------------------

         -- Has side effects:
         function Get_Record_Definition
           return a_nodes_h.Record_Definition_Struct
         is
            Result : a_nodes_h.Record_Definition_Struct :=
              a_nodes_h.Support.Default_Record_Definition_Struct;

            procedure Add_Record_Components is begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Record_Components (Element),
                  Dot_Label_Name => "Record_Components",
                  List_Out       => Result.Record_Components,
                  Add_Edges      => True);
            end;

            procedure Add_Implicit_Components is begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Implicit_Components (Element),
                  Dot_Label_Name => "Implicit_Components",
                  List_Out       => Result.Implicit_Components,
                  Add_Edges      => True);
            end;

         begin
            Add_Record_Components;
            Add_Implicit_Components;
            return Result;
         end Get_Record_Definition;

         -----------------------------------------------------------------------

         -- Has side effects:
         function Get_Task_Definition
           return a_nodes_h.Task_Definition_Struct
         is
            Result : a_nodes_h.Task_Definition_Struct :=
              a_nodes_h.Support.Default_Task_Definition_Struct;

            procedure Add_Has_Task is
               Value : constant Boolean := Asis.Elements.Has_Task (Element);
            begin
               State.Add_To_Dot_Label ("Has_Task", Value'Image);
               Result.Has_Task := a_nodes_h.Support.To_bool (Value);
            end;

            procedure Add_Visible_Part_Items is begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Visible_Part_Items (Element),
                  Dot_Label_Name => "Visible_Part_Items",
                  List_Out       => Result.Visible_Part_Items,
                  Add_Edges      => True);
            end;

            procedure Add_Private_Part_Items is begin
               Add_Element_List
                 (This           => State,
                  Elements_In    => Asis.Definitions.Private_Part_Items (Element),
                  Dot_Label_Name => "Private_Part_Items",
                  List_Out       => Result.Private_Part_Items,
                  Add_Edges      => True);
            end;

            procedure Add_Is_Private_Present is
               Value : constant Boolean :=
                 Asis.Definitions.Is_Private_Present (Element);
            begin
               State.Add_To_Dot_Label ("Is_Private_Present", Value'Image);
               Result.Is_Private_Present := a_nodes_h.Support.To_bool (Value);
            end;

         begin
            Add_Has_Task;
            Add_Visible_Part_Items;
            Add_Private_Part_Items;
            Add_Is_Private_Present;
            return Result;
         end Get_Task_Definition;

         -----------------------------------------------------------------------

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Definition_Kind", Definition_Kind'Image);
            Result.Definition_Kind := anhS.To_Definition_Kinds (Definition_Kind);
         end Add_Common_Items;

         -----------------------------------------------------------------------

         use all type Asis.Definition_Kinds;
      begin -- Process_Definition
         If Definition_Kind = Not_A_Definition then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Definition_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Definition_Kind is
            when Not_A_Definition =>
               raise Program_Error with
                 "Element.Pre_Children.Process_Definition called with: " &
                 Definition_Kind'Image;
            when A_Type_Definition =>
               Result.The_Union.The_Type_Definition := Get_Type_Definition;
            when A_Subtype_Indication =>
               Result.The_Union.The_Subtype_Indication := Get_Subtype_Indication;
            when A_Constraint =>
               Result.The_Union.The_Constraint := Get_Constraint;
            when A_Component_Definition =>

               State.Add_Not_Implemented;
            when A_Discrete_Subtype_Definition =>
               State.Add_Not_Implemented;
            when A_Discrete_Range =>
               State.Add_Not_Implemented;
            when An_Unknown_Discriminant_Part =>
               -- No more components:
               null;
            when A_Known_Discriminant_Part =>
               State.Add_Not_Implemented;
            when A_Record_Definition =>
               Result.The_Union.The_Record_Definition := Get_Record_Definition;
            when A_Null_Record_Definition =>
               null; -- No more components
            when A_Null_Component =>
               null; -- No more components
            when A_Variant_Part =>
               State.Add_Not_Implemented;
            when A_Variant =>
               State.Add_Not_Implemented;
            when An_Others_Choice =>
               null; -- No more components
            when An_Access_Definition =>
               -- Access_Definition_Kinds
               State.Add_Not_Implemented;
            when A_Private_Type_Definition =>
               State.Add_Not_Implemented;
            when A_Tagged_Private_Type_Definition =>
               State.Add_Not_Implemented;
            when A_Private_Extension_Definition =>
               State.Add_Not_Implemented;
            when A_Task_Definition =>
               Result.The_Union.The_Task_Definition := Get_Task_Definition;
            when A_Protected_Definition =>
               State.Add_Not_Implemented;
            when A_Formal_Type_Definition =>
               State.Add_Not_Implemented;
            when An_Aspect_Specification =>
               State.Add_Not_Implemented;
         end case;

         State.A_Element.Element_Kind := a_nodes_h.A_Definition;
         State.A_Element.The_Union.Definition := Result;
      end Process_Definition;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Expression
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Expression";
         Result : a_nodes_h.Expression_Struct :=
           a_nodes_h.Support.Default_Expression_Struct;

         Expression_Kind : Asis.Expression_Kinds :=
           Asis.Elements.Expression_Kind (Element);

         -- Supporting procedures are in alphabetical order:
         procedure Add_Converted_Or_Qualified_Expression is
            ID : constant Types.Node_Id := Asis.Set_Get.Node
              (Asis.Expressions.Converted_Or_Qualified_Expression (Element));
         begin
            State.Add_To_Dot_Label_And_Edge
              ("Converted_Or_Qualified_Expression", ID);
            Result.Converted_Or_Qualified_Expression :=
              a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Converted_Or_Qualified_Subtype_Mark is
            ID : constant Types.Node_Id := Asis.Set_Get.Node
              (Asis.Expressions.Converted_Or_Qualified_Subtype_Mark (Element));
         begin
            State.Add_To_Dot_Label_And_Edge
              ("Converted_Or_Qualified_Subtype_Mark", ID);
            Result.Converted_Or_Qualified_Subtype_Mark :=
              a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Called_Function is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Corresponding_Called_Function
                                 (Element));
         begin
            State.Add_To_Dot_Label
              ("Corresponding_Called_Function", To_String (ID));
            Result.Corresponding_Called_Function := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Expression_Type is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Corresponding_Expression_Type
                                 (Element));
         begin
            State.Add_To_Dot_Label
              ("Corresponding_Expression_Type", To_String (ID));
            Result.Corresponding_Expression_Type := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Name_Declaration is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Corresponding_Name_Declaration
                                 (Element));
         begin
            State.Add_To_Dot_Label
              ("Corresponding_Name_Declaration", To_String (ID));
            Result.Corresponding_Name_Declaration := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Name_Definition is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Corresponding_Name_Definition
                                 (Element));
         begin
            State.Add_To_Dot_Label
              ("Corresponding_Name_Definition", To_String (ID));
            Result.Corresponding_Name_Definition := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Name_Definition_List is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Expressions.
                 Corresponding_Name_Definition_List (Element),
               Dot_Label_Name => "Corresponding_Name_Definition_List",
               List_Out       => Result.Corresponding_Name_Definition_List);
         end;

         procedure Add_Function_Call_Parameters is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Expressions.
                 Function_Call_Parameters (Element),
               Dot_Label_Name => "Function_Call_Parameters",
               List_Out       => Result.Function_Call_Parameters,
               Add_Edges      => True);
         end;

         procedure Add_Name_Image is
            WS : constant Wide_String := Asis.Expressions.Name_Image (Element);
         begin
            State.Add_To_Dot_Label ("Name_Image", To_Quoted_String (WS));
            Result.Name_Image := To_Chars_Ptr (WS);
         end;

         procedure Add_Prefix is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Prefix (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Prefix", ID);
            Result.Prefix := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Selector is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Selector (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Selector", ID);
            Result.Selector := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Subpool_Name is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Subpool_Name (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Subpool_Name", ID);
            Result.Subpool_Name := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Value_Image is
            WS : constant Wide_String := Asis.Expressions.Value_Image (Element);
            use all type Asis.Expression_Kinds;
         begin
            State.Add_To_Dot_Label
              ("Value_Image",
               (if Expression_Kind = A_String_Literal then
                     To_Quoted_String (WS)
                else
                     To_String (WS)));
            Result.Value_Image := To_Chars_Ptr(WS);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Expression_Kind", Expression_Kind'Image);
            Result.Expression_Kind := anhS.To_Expression_Kinds (Expression_Kind);
            Add_Corresponding_Expression_Type;
         end Add_Common_Items;

         use all type Asis.Expression_Kinds;
      begin
         If Expression_Kind = Not_An_Expression then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Expression_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Expression_Kind is
            when Not_An_Expression =>
               raise Program_Error with
                 Module_Name & " called with: " & Expression_Kind'Image;
            when A_Box_Expression =>
               -- No more info:
               null;
            when An_Integer_Literal =>
               Add_Value_Image;
            when A_Real_Literal =>
               Add_Value_Image;
            when A_String_Literal =>
               Add_Value_Image;
            when An_Identifier =>
               Add_Name_Image;
               Add_Corresponding_Name_Definition;
               Add_Corresponding_Name_Definition_List;
               Add_Corresponding_Name_Declaration;
            when An_Operator_Symbol =>
               Add_Name_Image;
               Add_Corresponding_Name_Definition;
               Add_Corresponding_Name_Definition_List;
               Add_Corresponding_Name_Declaration;
               Result.Operator_Kind := Add_Operator_Kind (State, Element);
            when A_Character_Literal =>
               Add_Name_Image;
               Add_Corresponding_Name_Definition;
               Add_Corresponding_Name_Definition_List;
               Add_Corresponding_Name_Declaration;
            when An_Enumeration_Literal =>
               Add_Name_Image;
               Add_Corresponding_Name_Definition;
               Add_Corresponding_Name_Definition_List;
               Add_Corresponding_Name_Declaration;
            when An_Explicit_Dereference =>
               State.Add_Not_Implemented;
            when A_Function_Call =>
               Add_Prefix;
               Add_Corresponding_Called_Function;
               Add_Function_Call_Parameters;
            when An_Indexed_Component =>
               State.Add_Not_Implemented;
            when A_Slice =>
               State.Add_Not_Implemented;
            when A_Selected_Component =>
               Add_Prefix;
               Add_Selector;
            when An_Attribute_Reference =>
               State.Add_To_Dot_Label ("Attribute_Kind",
                                    Asis.Elements.Attribute_Kind (Element)'Image);
               -- Prefix
               -- Attribute_Designator_Identifier
               -- Attribute_Designator_Expressions
               State.Add_Not_Implemented;
            when A_Record_Aggregate =>
               State.Add_Not_Implemented;
            when An_Extension_Aggregate =>
               State.Add_Not_Implemented;
            when A_Positional_Array_Aggregate =>
               State.Add_Not_Implemented;
            when A_Named_Array_Aggregate =>
               State.Add_Not_Implemented;
            when An_And_Then_Short_Circuit =>
               State.Add_Not_Implemented;
            when An_Or_Else_Short_Circuit =>
               State.Add_Not_Implemented;
            when An_In_Membership_Test =>
               State.Add_Not_Implemented;
            when A_Not_In_Membership_Test =>
               State.Add_Not_Implemented;
            when A_Null_Literal =>
               -- No more information:
               null;
               State.Add_Not_Implemented;
            when A_Parenthesized_Expression =>
               State.Add_Not_Implemented;
            when A_Raise_Expression =>
               State.Add_Not_Implemented;
            when A_Type_Conversion =>
               Add_Converted_Or_Qualified_Subtype_Mark;
               Add_Converted_Or_Qualified_Expression;
            when A_Qualified_Expression =>
               State.Add_Not_Implemented;
            when An_Allocation_From_Subtype =>
               Add_Subpool_Name;
               State.Add_Not_Implemented;
            when An_Allocation_From_Qualified_Expression =>
               Add_Subpool_Name;
               State.Add_Not_Implemented;
            when A_Case_Expression =>
               State.Add_Not_Implemented;
            when An_If_Expression =>
               State.Add_Not_Implemented;
            when A_For_All_Quantified_Expression =>
               State.Add_Not_Implemented;
            when A_For_Some_Quantified_Expression =>
               State.Add_Not_Implemented;
         end case;

         State.A_Element.Element_Kind := a_nodes_h.An_Expression;
         State.A_Element.The_Union.Expression := Result;
      end Process_Expression;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Association
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Association";
         Result : a_nodes_h.Association_Struct :=
           a_nodes_h.Support.Default_Association_Struct;

         Association_Kind : Asis.Association_Kinds :=
           Asis.Elements.Association_Kind (Element);

         procedure Add_Formal_Parameter is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Formal_Parameter (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Formal_Parameter", ID);
            Result.Formal_Parameter := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Actual_Parameter is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Expressions.Actual_Parameter (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Actual_Parameter", ID);
            Result.Actual_Parameter := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Is_Defaulted_Association is
            Value : constant Boolean := Asis.Expressions.Is_Defaulted_Association (Element);
         begin
            State.Add_To_Dot_Label ("Is_Defaulted_Association", Value'Image);
            Result.Is_Defaulted_Association :=
              a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Normalized is
            Value : constant Boolean := Asis.Expressions.Is_Normalized (Element);
         begin
            State.Add_To_Dot_Label ("Is_Normalized", Value'Image);
            Result.Is_Normalized := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Association_Kind", Association_Kind'Image);
            Result.Association_Kind := anhS.To_Association_Kinds (Association_Kind);
         end Add_Common_Items;

         use all type Asis.Association_Kinds;
      begin
         If Association_Kind = Not_An_Association then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Association_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Association_Kind is
            when Not_An_Association =>                         -- An unexpected element
               raise Program_Error with
               Module_Name & " called with: " & Association_Kind'Image;
            when A_Pragma_Argument_Association =>
--                 Add_Formal_Parameter;
--                 Add_Actual_Parameter;
               State.Add_Not_Implemented;
            when A_Discriminant_Association =>
--                 Add_Discriminant_Selector_Names;
--                 Add_Discriminant_Expression;
--                 Add_Is_Normalized;
               State.Add_Not_Implemented;
            when A_Record_Component_Association =>
--                 Add_Record_Component_Choices;
--                 Add_Component_Expression;
--                 Add_Is_Normalized;
--                 Add_Is_Defaulted_Association;
               State.Add_Not_Implemented;
            when An_Array_Component_Association =>
--                 Add_Array_Component_Choices;
--                 Add_Component_Expression;
               State.Add_Not_Implemented;
            when A_Parameter_Association |
                 A_Generic_Association =>
               Add_Formal_Parameter;
               Add_Actual_Parameter;
               Add_Is_Defaulted_Association;
               Add_Is_Normalized;
         end case;

         State.A_Element.Element_Kind := a_nodes_h.An_Association;
         State.A_Element.The_union.association := Result;
      end Process_Association;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Statement
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Statement";
         Result : a_nodes_h.Statement_Struct :=
           a_nodes_h.Support.Default_Statement_Struct;

         Statement_Kind : constant Asis.Statement_Kinds :=
           Asis.Elements.Statement_Kind (Element);

         -- Supporting procedures are in alphabetical order:
         procedure Add_Accept_Body_Exception_Handlers is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Accept_Body_Exception_Handlers (Element),
               Dot_Label_Name => "Accept_Body_Exception_Handlers",
               List_Out       => Result.Accept_Body_Exception_Handlers,
               Add_Edges      => True);
         end;

         procedure Add_Accept_Body_Statements is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Accept_Body_Statements (Element),
               Dot_Label_Name => "Accept_Body_Statements",
               List_Out       => Result.Accept_Body_Statements,
               Add_Edges      => True);
         end;

         procedure Add_Accept_Entry_Direct_Name is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Accept_Entry_Direct_Name (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Accept_Entry_Direct_Name", ID);
            Result.Accept_Entry_Direct_Name := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Accept_Entry_Index is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Accept_Entry_Index (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Accept_Entry_Index", ID);
            Result.Accept_Entry_Index := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Accept_Parameters is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Accept_Parameters (Element),
               Dot_Label_Name => "Accept_Parameters",
               List_Out       => Result.Accept_Parameters,
               Add_Edges      => True);
         end;

         procedure Add_Assignment_Expression is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Assignment_Expression (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Assignment_Expression", ID);
            Result.Assignment_Expression := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Assignment_Variable_Name is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Assignment_Variable_Name (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Assignment_Variable_Name", ID);
            Result.Assignment_Variable_Name := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Associated_Message is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Associated_Message (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Associated_Message", ID);
            Result.Associated_Message := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Call_Statement_Parameters is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Call_Statement_Parameters (Element),
               Dot_Label_Name => "Call_Statement_Parameters",
               List_Out       => Result.Call_Statement_Parameters,
               Add_Edges      => True);
         end;

         procedure Add_Called_Name is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Called_Name (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Called_Name", ID);
            Result.Called_Name := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Called_Entity is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Corresponding_Called_Entity (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Called_Entity", To_String (ID));
            Result.Corresponding_Called_Entity := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Corresponding_Entry is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Corresponding_Entry (Element));
         begin
            State.Add_To_Dot_Label ("Corresponding_Entry", To_String (ID));
            Result.Corresponding_Entry := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Is_Name_Repeated is
            Value : constant Boolean := Asis.Statements.Is_Name_Repeated (Element);
         begin
            State.Add_To_Dot_Label ("Is_Name_Repeated", Value'Image);
            Result.Is_Name_Repeated := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Label_Names is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Label_Names (Element),
               Dot_Label_Name => "Label_Names",
               List_Out       => Result.Label_Names,
               Add_Edges      => True);
         end;

         procedure Add_Loop_Statements is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Loop_Statements (Element),
               Dot_Label_Name => "Loop_Statements",
               List_Out       => Result.Loop_Statements,
               Add_Edges      => True);
         end;

         procedure Add_Raised_Exception is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Raised_Exception (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Raised_Exception", ID);
            Result.Raised_Exception := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Return_Expression is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Return_Expression (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Return_Expression", ID);
            Result.Return_Expression := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Statement_Identifier is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Statement_Identifier (Element));
         begin
            State.Add_To_Dot_Label ("Statement_Identifier", To_String (ID));
            Result.Statement_Identifier := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Statement_Paths is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Statement_Paths (Element),
               Dot_Label_Name => "Statement_Paths",
               List_Out       => Result.Statement_Paths,
               Add_Edges      => True);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Statement_Kind", Statement_Kind'Image);
            Result.Statement_Kind := anhS.To_Statement_Kinds (Statement_Kind);
            Add_Label_Names;
         end Add_Common_Items;

         use all type Asis.Statement_Kinds;
      begin
         If Statement_Kind = Not_A_Statement then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Statement_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Statement_Kind is
            when Not_A_Statement =>
               raise Program_Error with
               Module_Name & " called with: " & Statement_Kind'Image;

            when A_Null_Statement =>
               null; -- No more info.

            when An_Assignment_Statement =>
               Add_Assignment_Variable_Name;
               Add_Assignment_Expression;

            when An_If_Statement =>
               Add_Statement_Paths;

            when A_Case_Statement =>
               State.Add_Not_Implemented;
               -- Case_Expression

            when A_Loop_Statement =>
               Add_Statement_Identifier;
               Add_Is_Name_Repeated;
               Add_Loop_Statements;

            when A_While_Loop_Statement =>
               State.Add_Not_Implemented;

            when A_For_Loop_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Identifier
               -- For_Loop_Parameter_Specification
               -- Loop_Statements

            when A_Block_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Identifier
               -- Is_Name_Repeated
               -- Is_Declare_Block
               -- Block_Declarative_Items
               -- Block_Statements
               -- Block_Exception_Handlers

            when An_Exit_Statement =>
               State.Add_Not_Implemented;
               -- Exit_Loop_Name
               -- Exit_Condition
               -- Corresponding_Loop_Exited

            when A_Goto_Statement =>
               State.Add_Not_Implemented;
               -- Goto_Label
               -- Corresponding_Destination_Statement

            when A_Procedure_Call_Statement =>
               Add_Called_Name;
               Add_Corresponding_Called_Entity;
               Add_Call_Statement_Parameters;

            when A_Return_Statement =>
               Add_Return_Expression;

            when An_Extended_Return_Statement =>
               State.Add_Not_Implemented;

            when An_Accept_Statement =>
               Add_Accept_Entry_Index;
               Add_Accept_Entry_Direct_Name;
               Add_Accept_Parameters;
               Add_Accept_Body_Statements;
               Add_Accept_Body_Exception_Handlers;
               Add_Corresponding_Entry;

            when An_Entry_Call_Statement =>
               Add_Called_Name;
               Add_Corresponding_Called_Entity;
               Add_Call_Statement_Parameters;

            when A_Requeue_Statement =>
               State.Add_Not_Implemented;
               -- Requeue_Entry_Name
            when A_Requeue_Statement_With_Abort =>
               State.Add_Not_Implemented;
               -- Requeue_Entry_Name

            when A_Delay_Until_Statement =>
               State.Add_Not_Implemented;
               -- Delay_Expression
            when A_Delay_Relative_Statement =>
               State.Add_Not_Implemented;
               -- Delay_Expression

            when A_Terminate_Alternative_Statement =>
               null; -- No more info

            when A_Selective_Accept_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Paths

            when A_Timed_Entry_Call_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Paths

            when A_Conditional_Entry_Call_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Paths

            when An_Asynchronous_Select_Statement =>
               State.Add_Not_Implemented;
               -- Statement_Paths

            when An_Abort_Statement =>
               State.Add_Not_Implemented;
               -- Aborted_Tasks

            when A_Raise_Statement =>
               Add_Raised_Exception;
               Add_Associated_Message;

            when A_Code_Statement =>
               State.Add_Not_Implemented;
               -- Qualified_Expression
         end case;

         State.A_Element.Element_Kind := a_nodes_h.A_Statement;
         State.A_Element.the_union.statement := Result;
      end Process_Statement;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Path
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Path";
         Result : a_nodes_h.Path_Struct :=
           a_nodes_h.Support.Default_Path_Struct;

         Path_Kind : constant Asis.Path_Kinds := Asis.Elements.Path_Kind (Element);

         procedure Add_Case_Path_Alternative_Choices is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Case_Path_Alternative_Choices (Element),
               Dot_Label_Name => "Case_Path_Alternative_Choices",
               List_Out       => Result.Case_Path_Alternative_Choices,
               Add_Edges      => True);
         end;

         procedure Add_Condition_Expression is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Condition_Expression (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Condition_Expression", ID);
            Result.Condition_Expression := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Guard is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Guard (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Guard", ID);
            Result.Guard := a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Sequence_Of_Statements is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Sequence_Of_Statements (Element),
               Dot_Label_Name => "Sequence_Of_Statements",
               List_Out       => Result.Sequence_Of_Statements,
               Add_Edges      => True);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Path_Kind", Path_Kind'Image);
            Result.Path_Kind := anhS.To_Path_Kinds (Path_Kind);
            Add_Sequence_Of_Statements;
         end Add_Common_Items;

         use all type Asis.Path_Kinds;
      begin
         If Path_Kind = Not_A_Path then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Path_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Path_Kind is
            when Not_A_Path =>
               raise Program_Error with
               Module_Name & " called with: " & Path_Kind'Image;
            when An_If_Path =>
               Add_Condition_Expression;
            when An_Elsif_Path =>
               Add_Condition_Expression;
            when An_Else_Path =>
               null; -- No more info
            when A_Case_Path =>
               Add_Case_Path_Alternative_Choices;
            when A_Select_Path =>
               Add_Guard;
            when An_Or_Path =>
               Add_Guard;
            when A_Then_Abort_Path =>
               null; -- No more info
            when A_Case_Expression_Path =>
               Add_Case_Path_Alternative_Choices;
            when An_If_Expression_Path =>
               Add_Condition_Expression;
            when An_Elsif_Expression_Path =>
               Add_Condition_Expression;
            when An_Else_Expression_Path =>
               null; -- No more info
         end case;

         State.A_Element.Element_Kind := a_nodes_h.A_Path;
         State.A_Element.The_Union.Path := Result;
      end Process_Path;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Clause
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Clause";
         Result : a_nodes_h.Clause_Struct :=
           a_nodes_h.Support.Default_Clause_Struct;

         Clause_Kind : constant Asis.Clause_Kinds :=
           Asis.Elements.Clause_Kind (Element);

         procedure Add_Clause_Names is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Clauses.Clause_Names (Element),
               Dot_Label_Name => "Clause_Name",
               List_Out       => Result.Clause_Names,
               Add_Edges      => True);
         end;

         procedure Add_Common_Items is
         begin
            State.Add_To_Dot_Label ("Clause_Kind", Clause_Kind'Image);
            Result.Clause_Kind := anhS.To_Clause_Kinds (Clause_Kind);
         end Add_Common_Items;

         use all type Asis.Clause_Kinds;
      begin
         If Clause_Kind = Not_A_Clause then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Clause_Kind'Image;
         else
            Add_Common_Items;
         end if;

         case Clause_Kind is
            when Not_A_Clause =>
               raise Program_Error with
                 "Element.Pre_Children.Process_Clause called with: " &
                 Clause_Kind'Image;
            when A_Use_Package_Clause =>
               Add_Clause_Names;
            when A_Use_Type_Clause =>
               Add_Clause_Names;
            when A_Use_All_Type_Clause =>
               Add_Clause_Names;
            when A_With_Clause =>
               Add_Has_Limited;
               Add_Clause_Names;
            when A_Representation_Clause =>
         --                                         -> Representation_Clause_Kinds
               State.Add_Not_Implemented;
            when A_Component_Clause =>
               State.Add_Not_Implemented;
         end case;

         State.A_Element.Element_Kind := a_nodes_h.A_Clause;
         State.A_Element.the_union.clause := Result;
      end Process_Clause;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      procedure Process_Exception_Handler
        (Element : in     Asis.Element;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Exception_Handler";
         Result : a_nodes_h.Exception_Handler_Struct :=
           a_nodes_h.Support.Default_Exception_Handler_Struct;

         procedure Add_Choice_Parameter_Specification is
            ID : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Statements.Choice_Parameter_Specification
                                 (Element));
         begin
            State.Add_To_Dot_Label_And_Edge ("Choice_Parameter_Specification", ID);
            Result.Choice_Parameter_Specification :=
              a_nodes_h.Node_ID (ID);
         end;

         procedure Add_Exception_Choices is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Exception_Choices (Element),
               Dot_Label_Name => "Exception_Choices",
               List_Out       => Result.Exception_Choices,
               Add_Edges      => True);
         end;

         procedure Add_Handler_Statements is
         begin
            Add_Element_List
              (This           => State,
               Elements_In    => Asis.Statements.Handler_Statements (Element),
               Dot_Label_Name => "Handler_Statements",
               List_Out       => Result.Handler_Statements,
               Add_Edges      => True);
         end;

      begin
         Add_Choice_Parameter_Specification;
         Add_Exception_Choices;
         Add_Handler_Statements;

         State.A_Element.Element_Kind := a_nodes_h.An_Exception_Handler;
         State.A_Element.the_union.exception_handler := Result;
      end Process_Exception_Handler;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      function Get_Enclosing_ID
        (Element : in Asis.Element)
         return Dot.ID_Type
      is
         Result : Dot.ID_Type; -- Initilaized
         Enclosing_Element_Id : constant Types.Node_Id :=
           Asis.Set_Get.Node_Value (Asis.Elements.Enclosing_Element (Element));
         Enclosing_Unit_Id : constant A4G.A_Types.Unit_Id :=
           Asis.Set_Get.Encl_Unit_Id (Element);
         function Enclosing_Is_Element return boolean
           is (Types."/=" (Enclosing_Element_Id, Types.Empty));
      begin
         if Enclosing_Is_Element then
            Result := To_Dot_ID_Type (Enclosing_Element_Id);
         else
            Result := To_Dot_ID_Type (Enclosing_Unit_Id);
         end if;
         return Result;
      end Get_Enclosing_ID;

      function Get_Enclosing_ID
        (Element : in Asis.Element)
         return a_nodes_h.Node_ID is
      begin
         return a_nodes_h.Node_ID
           (Asis.Set_Get.Node_Value
              (Asis.Elements.Enclosing_Element (Element)));
      end Get_Enclosing_ID;

      function Spec_Or_Body_Image
        (Unit_Class : in Asis.Unit_Classes)
         return String
      is
         use all type Asis.Unit_Classes;
      begin
         case Unit_Class is
            when Not_A_Class =>
               return "";
            when A_Public_Declaration |
                 A_Private_Declaration =>
               return ".ads";
            when A_Public_Body |
                 A_Private_Body |
                 A_Public_Declaration_And_Body |
                 A_Separate_Body =>
               return ".adb";
         end case;
      end Spec_Or_Body_Image;

      function Source_Location_Image
        (Unit_Name  : in String;
         Span       : in Asis.Text.Span)
         return String is
      begin
         return Unit_Name & " - " &
           NLB_Image (Span.First_Line) & ":" & NLB_Image (Span.First_Column) &
           " .. " &
           NLB_Image (Span.Last_Line) & ":" & NLB_Image (Span.Last_Column);
      end Source_Location_Image;

      --------------------------------------------------------------------------
      --------------------------------------------------------------------------

      ------------
      -- EXPORTED:
      ------------
      procedure Process_Element
        (Element : in     Asis.Element;
         Control : in out Asis.Traverse_Control;
         State   : in out Class)
      is
         Parent_Name : constant String := Module_Name;
         Module_Name : constant String := Parent_Name & ".Process_Element";
         Result : a_nodes_h.Element_Struct renames State.A_Element;

         Element_Kind : constant Asis.Element_Kinds :=
           Asis.Elements.Element_Kind (Element);

         procedure Add_Element_ID is begin
            State.Element_ID := Asis.Set_Get.Node (Element);
            State.Dot_Node.Node_ID.ID := To_Dot_ID_Type (State.Element_ID);
            State.Add_To_Dot_Label (To_String (State.Element_ID));
            -- ID is in the Dot node twice, but not in the a_node twice.
            Result.id := a_nodes_h.Node_ID (State.Element_ID);
         end;

         procedure Add_Element_Kind is begin
            State.Add_To_Dot_Label ("Element_Kind", Element_Kind'Image);
            Result.Element_Kind := anhS.To_Element_Kinds (Element_Kind);
         end;

         procedure Add_Source_Location is
            Unit : constant Asis.Compilation_Unit :=
              Asis.Elements.Enclosing_Compilation_Unit (Element);
            Unit_Class : constant Asis.Unit_Classes :=
              Asis.Compilation_Units.Unit_Class (Unit);
            Unit_Name : constant String := To_String
              (Asis.Compilation_Units.Unit_Full_Name (Unit)) &
              Spec_Or_Body_Image (Unit_Class);
            Span : constant Asis.Text.Span := Asis.Text.Element_Span (Element);

            Image : constant string := Source_Location_Image
              (Unit_Name, Span);
         begin
            State.Add_To_Dot_Label ("Source", Image);
            Result.Source_Location :=
              (Unit_Name    => To_Chars_Ptr (Unit_Name),
               First_Line   => Interfaces.C.int (Span.First_Line),
               First_Column => Interfaces.C.int (Span.First_Column),
               Last_Line    => Interfaces.C.int (Span.Last_Line),
               Last_Column  => Interfaces.C.int (Span.Last_Column));
         end;

         procedure Add_Is_Part_Of_Implicit is
            Value : constant Boolean := Asis.Elements.Is_Part_Of_Implicit (Element);
         begin
            State.Add_To_Dot_Label ("Is_Part_Of_Implicit", Value'Image);
            Result.Is_Part_Of_Implicit := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Part_Of_Inherited is
            Value : constant Boolean := Asis.Elements.Is_Part_Of_Inherited (Element);
         begin
            State.Add_To_Dot_Label ("Is_Part_Of_Inherited", Value'Image);
            Result.Is_Part_Of_Inherited := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Is_Part_Of_Instance is
            Value : constant Boolean := Asis.Elements.Is_Part_Of_Instance (Element);
         begin
            State.Add_To_Dot_Label ("Is_Part_Of_Instance", Value'Image);
            Result.Is_Part_Of_Instance := a_nodes_h.Support.To_bool (Value);
         end;

         procedure Add_Hash is
            Value : constant Asis.ASIS_Integer := Asis.Elements.Hash (Element);
         begin
            State.Add_To_Dot_Label ("Add_Hash", Value'Image);
            Result.Hash := a_nodes_h.ASIS_Integer (Value);
         end;

         procedure Add_Enclosing_Element is
             Value : constant Types.Node_Id :=
              Asis.Set_Get.Node (Asis.Elements.Enclosing_Element (Element));
         begin
--              State.Add_Dot_Edge (From  => Enclosing_Element_Id,
--                              To    => State.Element_Id,
--                              Label => "Child");
            State.Add_To_Dot_Label ("Enclosing_Element", Value'Image);
            Result.Enclosing_Element_Id :=
              a_nodes_h.Node_ID (Value);
         end;

         procedure Start_Output is
            Default_Node  : Dot.Node_Stmt.Class; -- Initialized
            Default_Label : Dot.HTML_Like_Labels.Class; -- Initialized
         begin
            State.Outputs.Text.Indent;
            State.Outputs.Text.End_Line;
            State.Outputs.Text.Put_Indented_Line (String'("BEGIN ELEMENT"));
            State.Dot_Node := Default_Node;
            State.Dot_Label := Default_Label;
            Result := a_nodes_h.Support.Default_Element_Struct;

            Add_Element_ID;
            Add_Element_Kind;
            Add_Source_Location;
            Add_Is_Part_Of_Implicit;
            Add_Is_Part_Of_Inherited;
            Add_Is_Part_Of_Instance;
            Add_Enclosing_Element;
            Add_Hash;
         end;

         procedure Finish_Output is
            A_Node : a_nodes_h.Node_Struct := anhS.Default_Node_Struct;
         begin
            State.Dot_Node.Add_Label (State.Dot_Label);

            State.Outputs.Graph.Append_Stmt
              (new Dot.Node_Stmt.Class'(State.Dot_Node));

            A_Node.Node_Kind := a_nodes_h.An_Element_Node;
            A_Node.The_Union.element := Result;
            State.Outputs.A_Nodes.Push (A_Node);

            State.Outputs.Text.End_Line;
            State.Outputs.Text.Dedent;
         end;

         use all type Asis.Element_Kinds;
      begin
         If Element_Kind = Not_An_Element then
            -- Redundant with the case below, but lets this if be clearer:
            raise Program_Error with
            Module_Name & " called with: " & Element_Kind'Image;
         else
            Start_Output;
         end if;

         case Element_Kind is
            when Not_An_Element =>
               raise Program_Error with
               Module_Name & " called with: " & Element_Kind'Image;
            when A_Pragma =>
               Process_Pragma (Element, State);
            when A_Defining_Name =>
               Process_Defining_Name (Element, State);
            when A_Declaration =>
               Process_Declaration (Element, State);
            when A_Definition =>
               Process_Definition (Element, State);
            when An_Expression =>
               Process_Expression (Element, State);
            when An_Association =>
               Process_Association (Element, State);
            when A_Statement =>
               Process_Statement (Element, State);
            when A_Path =>
               Process_Path (Element, State);
            when A_Clause =>
               Process_Clause (Element, State);
            when An_Exception_Handler =>
               Process_Exception_Handler (Element, State);
         end case;
--           Add_Enclosing_Element;
         Finish_Output;
      end Process_Element;

   end Pre_Children;


   package Post_Children is

      procedure Process_Element
        (Element :        Asis.Element;
         Control : in out Asis.Traverse_Control;
         State   : in out Class);

   end Post_Children;

   package body Post_Children is

      ------------
      -- EXPORTED:
      ------------
      procedure Process_Element
        (Element :        Asis.Element;
         Control : in out Asis.Traverse_Control;
         State   : in out Class) is
      begin
         State.Outputs.Text.Put_Indented_Line (String'("END ELEMENT"));
      end Process_Element;

   end Post_Children;


   -- Call Pre_Operation on ths element, call Traverse_Element on all children,
   -- then call Post_Operation on this element:
   procedure Traverse_Element is new
     Asis.Iterator.Traverse_Element
       (State_Information => Class,
        Pre_Operation     => Pre_Children.Process_Element,
        Post_Operation    => Post_Children.Process_Element);

   ------------
   -- EXPORTED:
   ------------
   procedure Process_Element_Tree
     (This    : in out Class;
      Element : in     Asis.Element;
      Outputs : in     Outputs_Record)
   is
      Process_Control : Asis.Traverse_Control := Asis.Continue;
   begin
      -- I would like to just pass Outputs through and not store it in the
      -- object, since it is all pointers and we doesn't need to store their
      -- values between calls to Process_Element_Tree. Outputs has to go into
      -- State_Information in the Traverse_Element instatiation, though, so
      -- we'll put it in the object and pass that:
      This.Outputs := Outputs;
      Traverse_Element
        (Element => Element,
         Control => Process_Control,
         State   => This);
   end Process_Element_Tree;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_To_Dot_Label
     (This  : in out Class;
      Name  : in     String;
      Value : in     String) is
   begin
-- Instead of this, put the "attribute" in the label:
--        This.Node.Attr_List.Add_Assign_To_First_Attr
--          (Name  => Name,
--           Value => Value);
      This.Dot_Label.Add_Eq_Row(L => Name, R => Value);
      This.Outputs.Text.Put_Indented_Line (Name & " => " & Value);
   end;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_To_Dot_Label
     (This  : in out Class;
      Name  : in     String;
      Value : in     Wide_String) is
   begin
      This.Add_To_Dot_Label (Name, To_String (Value));
   end;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_To_Dot_Label
     (This  : in out Class;
      Name  : in     String;
      ID    : in     Types.Node_Id) is
   begin
      This.Add_To_Dot_Label (Name, To_String (ID));
   end;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_To_Dot_Label
     (This  : in out Class;
      Value : in     String) is
   begin
      This.Dot_Label.Add_3_Col_Cell(Value);
      This.Outputs.Text.Put_Indented_Line (Value);
   end;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_Not_Implemented
     (This  : in out Class) is
   begin
      This.Add_To_Dot_Label ("ASIS_PROCESSING", String'("NOT_IMPLEMENTED_COMPLETELY"));
   end Add_Not_Implemented;


   -----------
   -- PRIVATE:
   -----------
   procedure Add_Dot_Edge
     (This  : in out Class;
      From  : in     Types.Node_Id;
      To    : in     Types.Node_Id;
      Label : in     String)
   is
      Edge_Stmt : Dot.Edges.Stmts.Class; -- Initialized
   begin
      if not Types."=" (To, Types.Empty) then
         Edge_Stmt.LHS.Node_Id.ID := To_Dot_ID_Type (From);
         Edge_Stmt.RHS.Node_Id.ID := To_Dot_ID_Type (To);
         Edge_Stmt.Attr_List.Add_Assign_To_First_Attr
           (Name  => "label",
            Value => Label);
         This.Outputs.Graph.Append_Stmt (new Dot.Edges.Stmts.Class'(Edge_Stmt));
      end if;
   end;

   -----------
   -- PRIVATE:
   -----------
   procedure Add_To_Dot_Label_And_Edge
     (This  : in out Class;
      Label : in     String;
      To    : in     Types.Node_Id) is
   begin
      This.Add_To_Dot_Label (Label, To_String (To));
      This.Add_Dot_Edge (From  => This.Element_ID,
                         To    => To,
                         Label => Label);
   end;

end Asis_Tool_2.Element;

