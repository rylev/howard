# Howard

Howard puts the fun into functional programming in Elixir! If you're used to
programming in other functional languages, and you miss such things as function
composition and currying, Howard has you covered!

## Usage

In order to use just add the following to your module:

```elixir
use Howard
```

## Function Compoisition

Howard supports two kinds of function composition:

### Backwards Function Composition

Backwards function composition (akin to . in Haskell) is achieved by using the
```<-``` operator.

```elixir
  f = fn x -> x + 2 end
  g = fn y -> y * 2 end

  # Tradition function application
  g.(f.(3)) #=> 10

  # Forwards function composition
  (g <- f).(3) #=> 10
```

### Forwards Function Composition

Fowards function composition (akin to >>> from Control.Arrow in Haskell) is
achieved by using the ```<>``` operator.

```elixir
  f = fn x -> x + 2 end
  g = fn y -> y * 2 end

  # Tradition function application
  g.(f.(3)) #=> 10

  # Forwards function composition
  (f <> g).(3) #=> 10
```

Don't worry, you'll still be able to use ```<>``` for string concatenation!

## Currying

If you want to curry your functions simply define them using ```defcurry```
instead of def.

```elixir
defmodule FunctionalMath do
  defcurry my_add(x, y) do
    x + y
  end
end

FunctionalMath.my_add #=>     #=> Function<0.56754824/1 in FunctionalMath.my_add/0>
FunctionalMath.my_add.(1)     #=> #Function<1.56754824/1 in FunctionalMath.my_add/0
FunctionalMath.my_add.(1).(2) #=> 3
```

## Partial Application

Want to partially apply a function? Use the ```partial/2``` function!

```elixir
my_func = partial(fn x,y,z -> (x + 2) * y - z end, [1,2])
my_func.(9)

double = partial(&Kernel.*/2, [2])
double.(3)  #=> 6
double.(42) #=> 84
```

## Who am I?

I'm Ryan Levick. You can find me on Twitter at @itchyankles or in real life in
Berlin, Germany!
