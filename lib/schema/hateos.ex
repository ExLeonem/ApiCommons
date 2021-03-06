defprotocol ApiCommons.Schema.Hateoas do

    @moduledoc """
        Generating Hateoas links

        To generate hateoas links we need API Routes.


        # HATEOAS standards
        - [JSON HAL](https://tools.ietf.org/html/draft-kelly-json-hal-08)
        - [Collections + JSON](http://amundsen.com/media-types/collection/format/)
        - [Verbose](https://verbose.readthedocs.io/en/latest/)
        - [Siren](https://github.com/kevinswiber/siren)
        - [JSON:API](https://jsonapi.org/)
    """

    # Protocol dummy
    # @spec link(t) :: String.t
    # def link(some_value)


end