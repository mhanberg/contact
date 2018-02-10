port module Update exposing (..)

import Model exposing (..)
import Http exposing (..)
import Json.Decode as Decode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRoomMessages (Just roomId) ->
            ( { model
                | roomId = Just roomId
              }
            , getSession ()
            )

        Session token ->
            ( model
            , get model.roomId token
            )

        InitialMessages (Ok s) ->
            ( { model
                | roomId = Just s
              }
            , Cmd.none
            )

        _ ->
            ( model, Cmd.none )


decodeResponse : Decode.Decoder String
decodeResponse =
    Decode.at [ "jsonapi", "version" ] Decode.string


get : Maybe String -> String -> Cmd Msg
get roomId token =
    case roomId of
        Nothing ->
            Cmd.none

        Just roomId ->
            let
                r =
                    request
                        { method = "GET"
                        , headers = [ header "Authorization" ("Bearer " ++ token) ]
                        , url = "/api/v1/rooms/" ++ roomId ++ "/messages"
                        , body = emptyBody
                        , expect = expectJson decodeResponse
                        , timeout = Nothing
                        , withCredentials = False
                        }
            in
                Http.send InitialMessages r


port getSession : () -> Cmd msg


port session : (String -> msg) -> Sub msg
