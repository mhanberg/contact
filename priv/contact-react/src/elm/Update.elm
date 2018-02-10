module Update exposing (..)

import Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRoomMessages roomId ->
            ( { model
                | roomId = roomId
              }
            , Cmd.none
            )
