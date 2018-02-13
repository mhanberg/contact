module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "panel panel-primary" ]
                    [ div [ class "panel-heading" ] [ text model.roomName ]
                    , div [ class "panel-body" ]
                        [ div [ class "well chat-box", id "chatBox" ]
                            [ model.messages
                                |> List.map renderMessage
                                |> div [ class "message-log" ]
                            ]
                        ]
                    , div [ class "panel-footer" ]
                        [ div [ class "row" ]
                            [ div [ class "col-xs-8 col-sm-10" ] [ input [ type_ "text", value model.newMessage, onInput SetNewMessage, placeholder "Type your message...", class "form-control", maxlength 255 ] [] ]
                            , div [ class "col-xs-4 col-sm-2" ] [ button [ class "btn btn-danger", onClick SendMessage ] [ text "Send!" ] ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


renderMessage : Message -> Html Msg
renderMessage message =
    div [ class "message bottom-border message-row-padding row" ]
        [ div [ class "sender col-xs-12 col-sm-2" ] [ text message.sender_id ]
        , div [ class "body col-xs-12 col-sm-10 break-word" ] [ text message.body ]
        ]
