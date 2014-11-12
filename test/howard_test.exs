defmodule HowardTest do
  use ExUnit.Case
  use Howard

  defmodule Foo do
    def concat(x, y) do
      x <> y
    end
    def f(x), do: x + 2
    def g(y), do: y * 2
    def h(y), do: div(y, 2)

    defcurry hello(lol, dude) do
      "#{lol} and #{dude}"
    end
  end

  test "compose functions backwards" do
    f = fn x -> x + 2 end
    g = fn y -> y * 2 end
    h = fn y -> div(y, 2) end

    assert (g <- f <- h).(3) == g.(f.(h.(3)))
  end


  test "compose functions forwards" do
    f = fn x -> x + 2 end
    g = fn y -> y * 2 end
    h = fn y -> div(y, 2) end

    assert (g <> f <> h).(3) == h.(f.(g.(3)))
  end

  test "compose module functions forwards" do
    assert ((&Foo.g/1) <> (&Foo.g/1) <> (&Foo.h/1)).(3) == Foo.h(Foo.g(Foo.g(3)))
  end

  test "<> for string concat is not overwritten" do
    assert "hello, " <> "world" == "hello, world"
  end

  test "defcurry" do
    assert Foo.hello.(1).(3) == "1 and 3"
  end

  test "partial" do
    assert partial(fn x,y ->  x <> y end, []).("hello, ").("world") == "hello, world"
    assert partial(fn x,y ->  x <> y end, ["hello, "]).("world") == "hello, world"
    assert partial(fn x,y ->  x <> y end, ["hello, ", "world"]) == "hello, world"
    assert partial((&Foo.concat/2), ["hello, "]).("world") == "hello, world"
  end
end
