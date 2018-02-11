port module Chat exposing (main)

import Html exposing (..)
import Model exposing (..)
import Update exposing (update, session)
import View exposing (view)
import Phoenix.Socket


main : Program Flags Model Msg
main =
    programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        msg =
            GetRoomMessages flags.roomId
    in
        update msg (Model.start flags)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ session Session, Phoenix.Socket.listen model.phxSocket PhoenixMsg ]
