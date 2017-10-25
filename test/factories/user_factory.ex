defmodule Contact.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Contact.Accounts.User{
          username: "legoman25",
          email: "legoman25@aol.com",
          first_name: "Mitch",
          last_name: "Hanberg",
          password_digest: "password"
        }
      end
    end
  end
end
