defmodule ApiCommons.Resource do

    @moduledoc """

    """
    
    alias __MODULE__
    alias ApiCommons.Request

    @verbs [:get, :post, :patch, :delete, :options, :connect, :trace, :head]

    def init(opts), do: opts

    def call(conn, _), do: Plug.Conn.send_resp(conn, 405, "")


    defmacro match_all_but(verbs, path, plug, plug_opts, options \\ []) do
        
        for verb <- @verbs -- verbs do
            quote bind_quoted: binding() do
                match(verb, path, plug, plug_opts, options)
            end
        end
    end


    defmacro resource(path, controller, opts \\ []) do
        defaults = quote bind_quoted: binding() do
            resources path, controller, opts
        end

        catch_alls = quote bind_quoted: binding() do
            match_all_but([:get, :post], path, RestResource, [])
            match_all_but([:get, :put, :patch, :delete], path <> "/:id", RestResource, [])
            match_all_but([:get], path <> "/:id/edit", RestResource, [])
        end

        quote do
            unquote(defaults)
            unquote(catch_alls)
        end
    end



    @doc """
    Build an API resource.

    Returns: Plug.Conn

    ## Parameter
        
    ## 
    """
    def build(conn, build_fn) do
        is_valid? = Request.valid?(conn)
        if is_valid? do
            data = Request.data(conn)
            result = apply(build_fn, [data.parsed])
        end
    end

end