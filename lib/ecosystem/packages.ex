defmodule Ecosystem.Packages do
  use Ash.Domain,
    otp_app: :ashes

  resources do
    resource Ecosystem.Packages.Tag
    resource Ecosystem.Packages.Package
    resource Ecosystem.Packages.PackageTag
  end
end
