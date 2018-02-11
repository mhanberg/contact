module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Task exposing (Task)
import Dom exposing (..)
import Dom.Scroll exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (model.roomId) ]
        , div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "well chat-box", id "chatBox" ]
                    [ div [ class "message-log" ]
                        (List.map renderMessage model.messages)
                    ]
                ]
            ]
        , div [ class "row" ]
            [ div [ class "col-xs-8 col-sm-10" ] [ input [ type_ "text", value model.newMessage, onInput SetNewMessage, placeholder "Type your message...", class "form-control" ] [] ]
            , div [ class "col-xs-4 col-sm-2" ] [ button [ class "btn btn-danger", onClick SendMessage ] [ text "Send!" ] ]
            ]
        ]


renderMessage : Message -> Html Msg
renderMessage message =
    div [ class "message bottom-border message-row-padding row" ]
        [ div [ class "sender col-xs-12 col-sm-2" ] [ text "sender:" ]
        , div [ class "body col-xs-12 col-sm-10" ] [ text message.body ]
        ]


scrollBottom : Id -> Task Error ()
scrollBottom id =
    Dom.Scroll.toBottom id
