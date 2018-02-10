port module Chat exposing (main)

import Html exposing (..)
import Model exposing (..)
import Update exposing (update)
import View exposing (view)


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
            GetRoomMessages flags
    in
        update msg Model.start


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
