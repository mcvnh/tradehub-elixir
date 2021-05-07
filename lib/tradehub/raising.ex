defmodule Tradehub.Raising do
  @moduledoc false

  @spec raising(any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro raising(name) do
    quote do
      @doc false
      def unquote(:"#{name}!")() do
        case unquote(:"#{name}")() do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro raising(name, p) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p)) do
        case unquote(:"#{name}")(unquote(p)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro raising(name, p1, p2) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p1), unquote(p2)) do
        case unquote(:"#{name}")(unquote(p1), unquote(p2)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p1), unquote(p2), unquote(p3)) do
        case unquote(:"#{name}")(unquote(p1), unquote(p2), unquote(p3)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any, any) :: {:__block__, [], [{:@, [...], [...]} | {:def, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p1), unquote(p2), unquote(p3), unquote(p4)) do
        case unquote(:"#{name}")(unquote(p1), unquote(p2), unquote(p3), unquote(p4)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end
end
