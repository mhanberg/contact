defmodule Contact.TeamFactory do
  defmacro __using__(_opts) do
    quote do
      def team_factory do
        %Contact.Teams.Team{
          name: sequence(:name, &"team#{&1}"),
          owner: build(:user),
          members: [build(:user)]
        }
      end
    end
  end
end
