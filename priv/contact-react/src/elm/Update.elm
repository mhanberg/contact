port module Update exposing (..)

import Model exposing (..)
import Http exposing (..)
import Dom
import Dom.Scroll exposing (..)
import Task exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Phoenix.Socket
import Phoenix.Push
import Phoenix.Channel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetRoomMessages roomId ->
            ( { model
                | roomId = roomId
              }
            , getSession ()
            )

        Session token ->
            ( model
            , get model.roomId token
            )

        InitialMessages (Ok s) ->
            ( { model
                | messages = s
              }
            , Task.attempt (\_ -> JoinChannel) scrollBottom
            )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        SendMessage ->
            let
                payload =
                    (Encode.object
                        [ ( "sender_id", Encode.string model.userId )
                        , ( "body", Encode.string model.newMessage )
                        , ( "room_id", Encode.string model.roomId )
                        , ( "sender_name", Encode.string model.userName )
                        ]
                    )

                push_ =
                    Phoenix.Push.init "new:msg" ("room:" ++ model.roomId)
                        |> Phoenix.Push.withPayload payload

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.push push_ model.phxSocket
            in
                ( { model
                    | newMessage = ""
                    , phxSocket = phxSocket
                  }
                , Cmd.map PhoenixMsg phxCmd
                )

        SetNewMessage msg ->
            ( { model | newMessage = msg }, Cmd.none )

        ReceiveChatMessage raw ->
            case Decode.decodeValue socketMessageDecoder raw of
                Ok chatMessage ->
                    ( { model | messages = List.append model.messages [ chatMessage ] }
                    , Task.attempt (\_ -> NoOp) scrollBottom
                    )

                Err error ->
                    ( model, Cmd.none )

        JoinChannel ->
            let
                channel =
                    Phoenix.Channel.init ("room:" ++ model.roomId)
                        |> Phoenix.Channel.withPayload (Encode.object [ ( "token", Encode.string model.token ) ])

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        _ ->
            ( model, Cmd.none )


decodeResponse : Decode.Decoder (List Message)
decodeResponse =
    let
        messageDecoder : Decode.Decoder Message
        messageDecoder =
            Decode.map3 Message (Decode.field "body" Decode.string) (Decode.field "sender_name" Decode.string) (Decode.field "sender_id" Decode.string)
    in
        Decode.at [ "data" ] (Decode.list messageDecoder)


socketMessageDecoder : Decode.Decoder Message
socketMessageDecoder =
    Decode.map3 Message (Decode.field "body" Decode.string) (Decode.field "sender_name" Decode.string) (Decode.field "sender_id" Decode.string)


get : String -> String -> Cmd Msg
get roomId token =
    case roomId of
        roomId ->
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


scrollBottom : Task Dom.Error ()
scrollBottom =
    Dom.Scroll.toBottom "chatBox"


port getSession : () -> Cmd msg


port session : (String -> msg) -> Sub msg
