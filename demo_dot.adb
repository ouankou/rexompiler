with Ada.Text_IO;
with Dot;

procedure Demo_Dot is

   package ATI renames Ada.Text_IO;

   procedure Print (Graph : in Dot.Graphs.Access_Class;
                   Title  : in String) is
   begin
      ATI.Put_Line ("// " & Title & ":");
      ATI.Put_Line ("//");
      Graph.Put;
      ATI.New_Line;
      ATI.New_Line;
   end;

   procedure Demo_Default_Graph is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Print (Graph, "Default Graph");
   end;

   procedure Demo_Graph is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);
      Print (Graph, "Graph");
   end;

   procedure Demo_Digraph is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (True);
      Graph.Set_Is_Strict (False);
      Print (Graph, "Digraph");
   end;

   procedure Demo_Strict_Graph is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (True);
      Print (Graph, "Strict Graph");
   end;

   procedure Demo_Strict_Digraph is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (True);
      Graph.Set_Is_Strict (True);
      Print (Graph, "Strict Digraph");
   end;

   procedure Demo_ID is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);
      Graph.Set_ID ("Some_ID");
      Print (Graph, "Graph with ID");
   end;

   procedure Demo_Reserved_ID is
      Graph : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);
      Graph.Set_ID ("graph");
      Print (Graph, "Graph with reserved word as ID");
   end;

   procedure Demo_Minimal_Node is
      Graph       : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_1 : Dot.Node_Stmt.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_1.Node_ID.ID := Dot.To_ID_Type ("minimal_node");
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_1));
      Print (Graph, "One minimal node");
   end;


   procedure Demo_Two_Nodes is
      Graph       : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_1 : Dot.Node_Stmt.Class; -- Initialized
      Node_Stmt_2 : Dot.Node_Stmt.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_1.Node_ID.ID := Dot.To_ID_Type ("minimal_node_1");
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_1));
      Node_Stmt_2.Node_ID.ID := Dot.To_ID_Type ("minimal_node_2");
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_2));
      Print (Graph, "Two minimal nodes");
   end;

   procedure Demo_One_Attr_Two_Assigns is
      Graph       : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_2 : Dot.Node_Stmt.Class; -- Initialized
      Attr_1      : Dot.Attr.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_2.Node_ID.ID := Dot.To_ID_Type ("node_with_attr");
      Attr_1.Assigns.Append ("Today", "Thursday");
      Attr_1.Assigns.Append ("Tomorrow", "Friday");
      Node_Stmt_2.Attrs.Append (Attr_1);
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_2));
      Print (Graph, "One node, one attr, two assigns");
   end;

   procedure Demo_Two_Attrs_One_Assign_Each is
      Graph       : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_2 : Dot.Node_Stmt.Class; -- Initialized
      Attr_1      : Dot.Attr.Class; -- Initialized
      Attr_2      : Dot.Attr.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_2.Node_ID.ID := Dot.To_ID_Type ("node_with_attrs");
      Attr_1.Assigns.Append ("Today", "Thursday");
      Node_Stmt_2.Attrs.Append (Attr_1);
      Attr_2.Assigns.Append ("Now", "Day");
      Node_Stmt_2.Attrs.Append (Attr_2);
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_2));
      Print (Graph, "One node, two attrs, one assign each");
   end;

   procedure Demo_Two_Attrs_No_Assigns is
      Graph         : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_2   : Dot.Node_Stmt.Class; -- Initialized
      Attr_1 : Dot.Attr.Class; -- Initialized
      Attr_2 : Dot.Attr.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_2.Node_ID.ID := Dot.To_ID_Type ("node_with_attrs");
      Node_Stmt_2.Attrs.Append (Attr_1);
      Node_Stmt_2.Attrs.Append (Attr_2);
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_2));
      Print (Graph, "One node, two attrs, no assigns");
   end;

   procedure Demo_Two_Nodes_Two_Attrs_Two_Assigns is
      Graph         : Dot.Graphs.Access_Class := new Dot.Graphs.Class;
      Node_Stmt_1   : Dot.Node_Stmt.Class; -- Initialized
      Node_Stmt_2   : Dot.Node_Stmt.Class; -- Initialized
      Attr_1 : Dot.Attr.Class; -- Initialized
      Attr_2 : Dot.Attr.Class; -- Initialized
      Attr_3 : Dot.Attr.Class; -- Initialized
      Attr_4 : Dot.Attr.Class; -- Initialized
   begin
      Graph.Set_Is_Digraph (False);
      Graph.Set_Is_Strict (False);

      Node_Stmt_1.Node_ID.ID := Dot.To_ID_Type ("node_1");
      Attr_1.Assigns.Append ("Today", "Thursday");
      Attr_1.Assigns.Append ("Tomorrow", "Friday");
      Node_Stmt_1.Attrs.Append (Attr_1);
      Attr_2.Assigns.Append ("Now", "Day");
      Attr_2.Assigns.Append ("Later", "Night");
      Node_Stmt_1.Attrs.Append (Attr_2);
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_1));

      Node_Stmt_2.Node_ID.ID := Dot.To_ID_Type ("node_2");
      Attr_3.Assigns.Append ("Today", "Thursday");
      Attr_3.Assigns.Append ("Yesterday", "Wednesday");
      Node_Stmt_2.Attrs.Append (Attr_3);
      Attr_4.Assigns.Append ("Now", "Day");
      Attr_4.Assigns.Append ("Before", "Morning");
      Node_Stmt_2.Attrs.Append (Attr_4);
      Graph.Append_Stmt (new Dot.Node_Stmt.Class'(Node_Stmt_2));
      Print (Graph, "Two nodes, two attrs, two assigns");
   end;

begin
   Demo_Default_Graph;
   Demo_Graph;
   Demo_Digraph;
   Demo_Strict_Graph;
   Demo_Strict_Digraph;
   Demo_ID;
   Demo_Reserved_ID;

   Demo_Minimal_Node;
   Demo_Two_Nodes;
   Demo_One_Attr_Two_Assigns;
   Demo_Two_Attrs_One_Assign_Each;
   Demo_Two_Attrs_No_Assigns;
   Demo_Two_Nodes_Two_Attrs_Two_Assigns;
end Demo_Dot;
