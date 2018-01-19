defmodule Contact.RoomFactory do
  defmacro __using__(_opts) do
    quote do
      def room_factory do
        %Contact.Rooms.Room{
          name: sequence(:name, &"room#{&1}"),
          owner: build(:user)
        }
      end
    end
  end
end
