defmodule Contact.TeamFactory do
  defmacro __using__(_opts) do
    quote do
      def team_factory do
        %Contact.Accounts.Team{
          name: sequence(:name, &"team#{&1}"),
          owner: build(:user)
        }
      end
    end
  end
end
