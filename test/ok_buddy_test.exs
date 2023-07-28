defmodule OkBuddyTest do
  use ExUnit.Case
  import OkBuddy

  test "prefix" do
    10
    |> prefix(:ok)
    |> then(&assert {:ok, 10} == &1)

    "string"
    |> prefix("this is a")
    |> then(&assert {"this is a", "string"} == &1)

    {:already_started, :pid}
    |> prefix(:error)
    |> then(&assert {:error, {:already_started, :pid}} == &1)
  end

  test "match" do
    {:red, 255}
    |> match({:red, num}, do: {:red, num - 55})
    |> then(&assert {:red, 200} == &1)

    {:red, 255}
    |> match({:blue, num}, do: {:blue, num - 255})
    |> then(&assert {:red, 255} == &1)
  end

  test "match infix(~>)" do
    :ok
    |> then(:ok ~> "success")
    |> then(&assert "success" == &1)

    {:error, "bad value"}
    |> then({:error, reason} ~> reason)
    |> then(&assert "bad value" == &1)

    :something
    |> then(:nothing ~> "fail")
    |> then(&assert :something == &1)
  end

  def add(left, right), do: left + right

  test "when_error" do
    {:error, {:already_started, :pid}}
    |> when_error(then(fn val -> val end))
    |> then(&assert {:already_started, :pid} == &1)

    {:error, 50}
    |> when_error(add(50))
    |> then(&assert 100 == &1)

    {:ok, 50}
    |> when_error(add(50))
    |> then(&assert {:ok, 50} == &1)
  end

  test "when_ok" do
    {:ok, 100}
    |> when_ok(then(fn num -> num + 50 end))
    |> then(&assert 150 == &1)

    {:ok, 50}
    |> when_ok(add(50))
    |> then(&assert 100 == &1)

    {:error, 50}
    |> when_ok(add(50))
    |> then(&assert {:error, 50} == &1)
  end
end
