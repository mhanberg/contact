# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Contact.Repo.insert!(%Contact.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
File.stream!("./priv/repo/fixtures/users.csv")
|> CSV.decode!(headers: true)
|> Enum.map(fn(user) -> 
  Contact.Accounts.create_user(%{
    "email" => user["email"],
    "username" => user["username"],
    "first_name" => user["first_name"],
    "last_name" => user["last_name"],
    "password" => user["password"],
    "password_confirmation" => user["password_confirmation"] 
  })
end)

File.stream!("./priv/repo/fixtures/teams.csv")
|> CSV.decode!(headers: true)
|> Enum.with_index()
|> Enum.map(fn({team, index}) -> 
  Contact.Teams.create_team(%{
    "name" => team["name"],
    "owner_id" => team["owner_id"] 
  })

  team["members"]
  |> String.split(";")
  |> Enum.map(fn(member_id) -> Contact.Teams.add_member(index + 1, member_id) end)
end)

File.stream!("./priv/repo/fixtures/rooms.csv")
|> CSV.decode!(headers: true)
|> Enum.with_index()
|> Enum.map(fn({room, index}) ->
  Contact.Rooms.create_room(%{
    "name" => room["name"],
    "owner_id" => room["owner_id"],
    "team_id" => room["team_id"]
  }) 

  room["members"]
  |> String.split(";")
  |> Enum.map(fn(member_id) -> Contact.Rooms.add_member(index + 1, member_id) end)
end)

File.stream!("./priv/repo/fixtures/messages.csv")
|> CSV.decode!(headers: true)
|> Enum.map(fn(message) ->
  Contact.Messages.create_message(%{
    "body" => message["body"],
    "sender_id" => message["sender_id"],
    "room_id" => message["room_id"]
  })
end)

