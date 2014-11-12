defmodule Howard do
  defmacro __using__(_opts) do
    quote do
      require Howard
      import Kernel, except: [{:<-, 2},{:<>, 2}]
      import Howard
    end
  end

  def (string1 <> string2) when is_binary(string1) and is_binary(string2) do
    Kernel.<>(string1, string2)
  end
  def f1 <> f2 do
    fn x -> f2.(f1.(x)) end
  end

  def f1 <- f2 do
    fn x -> f1.(f2.(x)) end
  end

  defmacro partial(func, args) do
     code = quote do
      arity = :erlang.fun_info(unquote(func)) |> Dict.get(:arity)
      arity - Enum.count(unquote(args))
    end

    {arity_difference, _} = Code.eval_quoted(code, [func: func], __ENV__)
    var_names = ?a..?z |> Enum.take(arity_difference) |> Enum.map fn char ->
      [char] |> to_string |> String.to_atom
    end

    extra_args = var_names |> Enum.reverse |> Enum.map &(Macro.var(&1, nil))
    function_call = quote do
      unquote(func).(unquote_splicing(args), unquote_splicing(extra_args))
    end

    var_names |> Enum.reduce function_call, fn var_name, accum ->
      quote do
        fn unquote(Macro.var(var_name, nil)) ->
          unquote(accum)
        end
      end
    end
  end

  defmacro defcurry({name, _, args}, [do: do_block]) do
    curry = args |> Enum.reverse |> Enum.reduce do_block, fn {name, _, _}, accum ->
      quote do
        fn unquote(Macro.var(name, nil)) ->
          unquote(accum)
        end
      end
    end
    quote do
      def unquote(name)(), do: unquote(curry)
    end
  end
end
