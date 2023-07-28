defmodule OkBuddy do
  # ====================================================================================
  # Prefix
  # ====================================================================================

  defmacro prefix(t, prefix), do: {prefix, t}

  # ====================================================================================
  # Match
  # ====================================================================================

  defmacro match(left, pattern, do: right) do
    quote do
      with unquote(pattern) <- unquote(left) do
        unquote(right)
      else
        other -> other
      end
    end
  end

  defmacro pattern ~> right do
    quote do
      fn left -> match(left, unquote(pattern), do: unquote(right)) end
    end
  end

  # ====================================================================================
  # When Ok
  # ====================================================================================

  defmacro when_ok(left, right) do
    quote do
      with {:ok, something} <- unquote(left) do
        something |> unquote(right)
      else
        {:error, _} = err -> err
      end
    end
  end

  # ====================================================================================
  # When Error
  # ====================================================================================

  defmacro when_error(left, right) do
    quote do
      with {:error, something} <- unquote(left) do
        something |> unquote(right)
      else
        other -> other
      end
    end
  end
end
