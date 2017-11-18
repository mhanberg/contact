defmodule Contact.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Contact.Accounts.User{
          username: sequence(:email, &"user#{&1}"),
          email: sequence(:email, &"email-#{&1}@example.com"),
          first_name: "Mitch",
          last_name: "Hanberg",
          password_digest: Comeonin.Bcrypt.hashpwsalt("password")
        }
      end
    end
  end
end
