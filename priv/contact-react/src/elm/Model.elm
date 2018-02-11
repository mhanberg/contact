module Model exposing (..)

import Http exposing (..)
import Phoenix.Socket
import Json.Encode


type Msg
    = NoOp
    | GetRoomMessages String
    | InitialMessages (Result Http.Error (List Message))
    | Session String
    | ReceiveChatMessage Json.Encode.Value
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | JoinChannel
    | SendMessage
    | SetNewMessage String


type alias Flags =
    { roomId : String
    , token : String
    , url : String
    , userId : String
    , roomName : String
    , userName : String
    }


type alias Model =
    { roomId : String
    , messages : List Message
    , phxSocket : Phoenix.Socket.Socket Msg
    , newMessage : String
    , token : String
    , userId : String
    , roomName : String
    , userName : String
    }


type alias Message =
    { body : String
    , sender_id : String
    , sender_name : String
    }


type alias Sender =
    { name : String
    , id : String
    }


start : Flags -> Model
start flags =
    { roomId = flags.roomId
    , token = flags.token
    , messages = []
    , newMessage = ""
    , userId = flags.userId
    , roomName = flags.roomName
    , userName = flags.userName
    , phxSocket =
        Phoenix.Socket.init
            (flags.url
                ++ "/socket/websocket?token="
                ++ flags.token
            )
            |> Phoenix.Socket.withDebug
            |> Phoenix.Socket.on "new:msg" ("room:" ++ flags.roomId) ReceiveChatMessage
    }
