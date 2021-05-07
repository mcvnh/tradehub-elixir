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

  @spec raising(any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
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

  @spec raising(any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
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

  @spec raising(any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
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

  @spec raising(any, any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4, p5) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p1), unquote(p2), unquote(p3), unquote(p4), unquote(p5)) do
        case unquote(:"#{name}")(unquote(p1), unquote(p2), unquote(p3), unquote(p4), unquote(p5)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4, p5, p6) do
    quote do
      @doc false
      def unquote(:"#{name}!")(unquote(p1), unquote(p2), unquote(p3), unquote(p4), unquote(p5), unquote(p6)) do
        case unquote(:"#{name}")(unquote(p1), unquote(p2), unquote(p3), unquote(p4), unquote(p5), unquote(p6)) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4, p5, p6, p7) do
    quote do
      @doc false
      def unquote(:"#{name}!")(
            unquote(p1),
            unquote(p2),
            unquote(p3),
            unquote(p4),
            unquote(p5),
            unquote(p6),
            unquote(p7)
          ) do
        case unquote(:"#{name}")(
               unquote(p1),
               unquote(p2),
               unquote(p3),
               unquote(p4),
               unquote(p5),
               unquote(p6),
               unquote(p7)
             ) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any, any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4, p5, p6, p7, p8) do
    quote do
      @doc false
      def unquote(:"#{name}!")(
            unquote(p1),
            unquote(p2),
            unquote(p3),
            unquote(p4),
            unquote(p5),
            unquote(p6),
            unquote(p7),
            unquote(p8)
          ) do
        case unquote(:"#{name}")(
               unquote(p1),
               unquote(p2),
               unquote(p3),
               unquote(p4),
               unquote(p5),
               unquote(p6),
               unquote(p7),
               unquote(p8)
             ) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end

  @spec raising(any, any, any, any, any, any, any, any, any, any) ::
          {:def, [{:context, Tradehub.Raising} | {:import, Kernel}, ...],
           [[{any, any}, ...] | {atom, [...], [...]}, ...]}
  defmacro raising(name, p1, p2, p3, p4, p5, p6, p7, p8, p9) do
    quote do
      @doc false
      def unquote(:"#{name}!")(
            unquote(p1),
            unquote(p2),
            unquote(p3),
            unquote(p4),
            unquote(p5),
            unquote(p6),
            unquote(p7),
            unquote(p8),
            unquote(p9)
          ) do
        case unquote(:"#{name}")(
               unquote(p1),
               unquote(p2),
               unquote(p3),
               unquote(p4),
               unquote(p5),
               unquote(p6),
               unquote(p7),
               unquote(p8),
               unquote(p9)
             ) do
          {:ok, body} -> body
          {:error, reason} -> raise reason
        end
      end
    end
  end
end
