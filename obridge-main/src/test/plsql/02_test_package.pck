Create Or Replace Package test_package Is

  Function get_sysdate Return Date;

  Procedure get_sysdate(p_sysdate Out Date);

  Procedure hello_world(p_name In Varchar2,
                        p_out  Out Varchar2);

  Procedure boolean_test_2(n          In Out Number,
                           bool_in    In Boolean,
                           bool_out   Out Boolean,
                           bool_inout In Out Boolean);

  Function boolean_test_1(p_bool In Boolean) Return Varchar2;

  Function object_type_test_1(p_object_type In Out sample_type_one) Return Number;

  Function table_of_test_1(p_list_of In Out sample_type_one_list) Return Number;

  Procedure combined_types_test_1(p_object_type In Out sample_type_one,
                                  p_list_of     In Out sample_type_one_list);

  Procedure all_types(n    In Out Number,
                      bi   In Out Binary_Integer,
                      pi   In Out Pls_Integer,
                      vch  In Out Varchar2,
                      nvch In Out Nvarchar2,
                      ch   In Out Char,
                      nch  In Out Nchar,
                      d    In Out Date,
                      ts   In Out Timestamp,
                      cl   In Out Clob,
                      b    In Out Boolean,
                      tbl  In Out sample_type_one_list, -- table of object
                      o    In Out sample_type_one -- object
                      );

  Procedure "quoted_Procedure_Name";

  Function "isItAGoodFunction"(p_param1 sample_type_one) Return Boolean;

  Function "function_returns_boolean"(param1 Varchar2) Return Boolean;

  Function simple_boolean_return Return Boolean;

  Function return_string_list Return simple_string_list;

  Function sum_list(p_list In simple_number_list) Return Number;

  Procedure test_many_name_list(p_tp In Out sample_type_lists);

  Procedure test_many_name_many(p_tp_group In Out sample_type_two_group,
                                p_tp_list  In Out sample_type_two_list);

End test_package;
/
Create Or Replace Package Body test_package Is

  Function get_sysdate Return Date Is
  Begin
    Return Sysdate;
  End get_sysdate;

  Procedure get_sysdate(p_sysdate Out Date) Is
  Begin
    p_sysdate := trunc(Sysdate);
  End get_sysdate;

  Procedure hello_world(p_name In Varchar2,
                        p_out  Out Varchar2) Is
  Begin
    p_out := 'Hello ' || p_name || '!';
  End hello_world;

  Procedure boolean_test_2(n          In Out Number,
                           bool_in    In Boolean,
                           bool_out   Out Boolean,
                           bool_inout In Out Boolean) Is
  Begin
    If n Is Not Null Then
      n := n + 1;
    Else
      raise_application_error(-20001,
                              'N cannot be NULL');
    End If;
    bool_out   := bool_in;
    bool_inout := Not bool_inout;
  End boolean_test_2;

  Function boolean_test_1(p_bool In Boolean) Return Varchar2 Is
  Begin
    Return Case When p_bool Then 'TRUE' When Not p_bool Then 'FALSE' Else 'NULL' End;
  End boolean_test_1;

  Function object_type_test_1(p_object_type In Out sample_type_one) Return Number Is
  Begin
    p_object_type.attr_varchar := 'Hello!';
    Return p_object_type.attr_int;
  End;

  Function table_of_test_1(p_list_of In Out sample_type_one_list) Return Number Is
  Begin
  
    If (p_list_of Is Null Or p_list_of.count = 0) Then
      p_list_of := sample_type_one_list();
    End If;
  
    p_list_of.extend;
    p_list_of(p_list_of.last) := sample_type_one(attr_varchar  => 'Hello!',
                                                 attr_clob     => Null,
                                                 attr_int      => p_list_of.count,
                                                 attr_bigdec_1 => Null,
                                                 attr_bigdec_2 => Null,
                                                 date_a        => Sysdate,
                                                 timest_b      => Null,
                                                 timest_c      => Null,
                                                 raw_col       => Null);
  
    Return p_list_of.count;
  
  End table_of_test_1;

  Procedure combined_types_test_1(p_object_type In Out sample_type_one,
                                  p_list_of     In Out sample_type_one_list) Is
    i Number;
  Begin
    i := object_type_test_1(p_object_type => p_object_type);
  
    i := table_of_test_1(p_list_of => p_list_of);
  
  End;

  Procedure all_types(n    In Out Number,
                      bi   In Out Binary_Integer,
                      pi   In Out Pls_Integer,
                      vch  In Out Varchar2,
                      nvch In Out Nvarchar2,
                      ch   In Out Char,
                      nch  In Out Nchar,
                      d    In Out Date,
                      ts   In Out Timestamp,
                      cl   In Out Clob,
                      b    In Out Boolean,
                      tbl  In Out sample_type_one_list, -- table of object
                      o    In Out sample_type_one -- object
                      ) Is
  Begin
    Null;
  End all_types;

  Procedure "quoted_Procedure_Name" Is
  Begin
    Null;
  End "quoted_Procedure_Name";

  Function "isItAGoodFunction"(p_param1 sample_type_one) Return Boolean Is
  Begin
    Return True;
  End "isItAGoodFunction";

  Function "function_returns_boolean"(param1 Varchar2) Return Boolean Is
  Begin
    Return True;
  End "function_returns_boolean";

  Function simple_boolean_return Return Boolean Is
  Begin
    Return True;
  End simple_boolean_return;

  Function return_string_list Return simple_string_list Is
    v_ret simple_string_list := simple_string_list();
  Begin
  
    v_ret.extend;
    v_ret(v_ret.count) := 'string1';
  
    v_ret.extend;
    v_ret(v_ret.count) := 'string2';
  
    v_ret.extend;
    v_ret(v_ret.count) := 'string3';
  
    Return v_ret;
  End return_string_list;

  Function sum_list(p_list In simple_number_list) Return Number Is
    x Number := 0;
  Begin
    If p_list Is Not Null Then
      If p_list.count != 0 Then
        For i In p_list.first .. p_list.last Loop
          x := x + p_list(i);
        End Loop;
        Return x;
      Else
        Return 0;
      End If;
    Else
      Return Null;
    End If;
  
  End sum_list;

  Procedure test_many_name_list(p_tp In Out sample_type_lists) Is
  Begin
    p_tp.list4.extend;
    p_tp.list4(p_tp.list4.last) := 'TEST';
  
    p_tp.list5.extend;
    p_tp.list5(p_tp.list5.last) := 3.5;
  
    p_tp.list6.extend;
    p_tp.list6(p_tp.list6.last) := 28;
  
    p_tp.list7.extend;
    p_tp.list7(p_tp.list7.last) := Date '2000-01-01';
  
  End test_many_name_list;

  Procedure test_many_name_many(p_tp_group In Out sample_type_two_group,
                                p_tp_list  In Out sample_type_two_list) Is
  Begin
    Null;
  End test_many_name_many;

End test_package;
/
