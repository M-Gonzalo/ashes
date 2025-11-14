defmodule Ashes.Accounts do
  use Ash.Domain, otp_app: :ashes, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Ashes.Accounts.Token
    resource Ashes.Accounts.User
  end
end
