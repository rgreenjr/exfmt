defmodule Exfmt.Integration.MapTest do
  use ExUnit.Case
  import Support.Integration

  test "maps" do
    "%{}" ~> "%{}\n"
    "%{a: 1}" ~> "%{a: 1}\n"
    "%{:a => 1}" ~> "%{a: 1}\n"
    "%{1 => 1}" ~> "%{1 => 1}\n"
    "%{1 => 1, 2 => 2}" ~> "%{1 => 1, 2 => 2}\n"
  end

  test "multiline maps" do
    assert_format """
    %{
      foo: 1,
      bar: 2,
      baz: 3,
      somereallylongkey: 4,
    }
    """

    """
    %{foo: 1, bar: 2, baz: 3, somereallylongkey: 4, theotherkey: 5}
    """ ~> """
    %{
      foo: 1,
      bar: 2,
      baz: 3,
      somereallylongkey: 4,
      theotherkey: 5,
    }
    """

    assert_format """
    var = %{
      foo: 1,
      bar: 2,
      baz: 3,
      somereallylongkey: 4,
    }
    """
  end

  test "map upsert %{map | key: value}" do
    "%{map | key: value}" ~> "%{map | key: value}\n"
  end

  test "chained map get" do
    assert_format "map.key.another.a_third\n"
  end

  test "qualified call into map get" do
    "Map.new.key" ~> "Map.new().key\n"
  end

  test "structs" do
    assert_format "%Person{}\n"
    assert_format "%Person{age: 1}\n"
    "%Person{timmy | age: 1}" ~> "%Person{timmy | age: 1}\n"
    """
    %LongerNamePerson{timmy | name: "Timmy", age: 1}
    """ ~> """
    %LongerNamePerson{
      timmy |
      name: "Timmy",
      age: 1
    }
    """
    assert_format "%Inspect.Opts{}\n"
  end

  test "struct assignments" do
    assert_format "datetime = %NaiveDateTime{year: 2017}\n"
    """
    datetime = %NaiveDateTime{calendar: Calendar.ISO}
    """ ~> """
    datetime =
      %NaiveDateTime{calendar: Calendar.ISO}
    """
    """
    %NaiveDateTime{calendar: Calendar.ISO} = datetime_struct
    """ ~> """
    %NaiveDateTime{calendar: Calendar.ISO} =
      datetime_struct
    """
    """
    %NaiveDateTime{calendar: calendar, day: day, month: month, year: year } =
    %NaiveDateTime{ calendar: Calendar.ISO, day: 1, month: 1, year: 2017}
    """ ~> """
    %NaiveDateTime{
      calendar: calendar,
      day: day,
      month: month,
      year: year
    } =
      %NaiveDateTime{
        calendar: Calendar.ISO,
        day: 1,
        month: 1,
        year: 2017
      }
    """
  end

  test "__MODULE__ structs" do
    assert_format "%__MODULE__.Person{}\n"
    assert_format "%__MODULE__{debug: true}\n"
  end

  test "variable type struct" do
    assert_format "%struct_type{}\n"
  end

  test "keys with spaces" do
    assert_format """
    %{"Implemented protocols": :ok}
    """
  end

  test "keys with dashes" do
    assert_format """
    %{"name-space": :ok}
    """
  end

  test "macro contents" do
    assert_format """
    %{unquote_splicing(spec)}
    """
  end

  test "update of map from function" do
    assert_format """
    %{zero(0) | rank: 1}
    """
  end

  test "struct with pinned type" do
    assert_format """
    %^struct{} = user
    """
  end

  test "struct with unquoted type" do
    assert_format """
    %unquote(User){foo: 1}
    """
  end

  test "range" do
    assert_format """
    1..2
    """
  end

  test "range.attribute" do
    assert_format """
    (1..2).first
    """
    assert_format """
    (1..2).last
    """
  end
end
