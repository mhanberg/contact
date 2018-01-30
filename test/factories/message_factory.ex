defmodule Contact.MessageFactory do
  defmacro __using__(_opts) do
    quote do
      def message_factory do
        %Contact.Messages.Message{
          body: sequence(:body, &"This is the #{&1} message of the chat room"),
          sender: build(:user),
          room: build(:room)
        }
      end
    end
  end
end
