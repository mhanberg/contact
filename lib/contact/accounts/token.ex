defmodule Contact.Accounts.Token do
  @enforce_keys [:token]
  defstruct [:token, :user]
end
