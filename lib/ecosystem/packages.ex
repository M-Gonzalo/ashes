defmodule Ecosystem.Packages do
  use Ash.Domain,
    otp_app: :ashes

  resources do
    resource Ecosystem.Packages.Tag do
      define :get_tag_by_name, action: :read, get_by: [:name]
    end

    resource Ecosystem.Packages.Package do
      define :add_github_repo, action: :add_github_repo

      define :get_packages,
        action: :packages,
        args: [:category, :official, :status, :tags, :search],
        get?: false
    end

    resource Ecosystem.Packages.PackageTag
  end
end
