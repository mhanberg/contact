defmodule Contact.Factory do
  use ExMachina.Ecto, repo: Contact.Repo
  use Contact.UserFactory
end
