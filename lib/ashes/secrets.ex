defmodule Ashes.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        Ashes.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:ashes, :token_signing_secret)
  end
end
