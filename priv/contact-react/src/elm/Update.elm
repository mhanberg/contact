module Update exposing (..)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model
                | count = model.count + 1
              }
            , Cmd.none
            )

        Decrement ->
            ( { model
                | count = model.count - 1
              }
            , Cmd.none
            )
