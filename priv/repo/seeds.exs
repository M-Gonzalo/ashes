alias Ecosystem.Packages.{Package, Tag, PackageTag}

require Ash.Query

# If you want a clean slate each time, uncomment this block:
#
# for resource <- [PackageTag, Tag, Package] do
#   resource
#   |> Ash.read!()
#   |> Enum.each(&Ash.destroy!/1)
# end

packages = [
  # Core framework
  %{
    name: "Ash",
    package: "ash",
    category: "core",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(core resources dsl),
    description:
      "The core Ash framework: a declarative, resource-oriented application layer for Elixir.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Core",
    package: "ash_core",
    category: "core",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(core resources),
    description: "Lower-level resource declaration and interaction library used inside Ash.",
    github_repo_handle: nil
  },

  # Data layers
  %{
    name: "AshPostgres",
    package: "ash_postgres",
    category: "data-layer",
    official: true,
    kind: "data-layer",
    status: "stable",
    tags: ~w(postgres ecto sql),
    description: "PostgreSQL data layer for Ash; the most feature-complete SQL backend.",
    github_repo_handle: nil
  },
  %{
    name: "AshSqlite",
    package: "ash_sqlite",
    category: "data-layer",
    official: true,
    kind: "data-layer",
    status: "stable",
    tags: ~w(sqlite sql),
    description: "SQLite data layer for Ash, using shared SQL utilities from ash_sql.",
    github_repo_handle: nil
  },
  %{
    name: "Ash CSV",
    package: "ash_csv",
    category: "data-layer",
    official: true,
    kind: "data-layer",
    status: "stable",
    tags: ~w(csv files),
    description: "CSV data layer for Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Neo4j",
    package: "ash_neo4j",
    category: "data-layer",
    official: false,
    kind: "data-layer",
    status: "stable",
    tags: ~w(neo4j graph community),
    description: "Neo4j data layer for Ash, for graph-style data models.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Sanity",
    package: "ash_sanity",
    category: "data-layer",
    official: false,
    kind: "data-layer",
    status: "stable",
    tags: ~w(cms sanity headless),
    description: "Data layer that maps Ash resources onto the Sanity.io headless CMS.",
    github_repo_handle: nil
  },

  # API & transport
  %{
    name: "AshPhoenix",
    package: "ash_phoenix",
    category: "api",
    official: true,
    kind: "integration",
    status: "stable",
    tags: ~w(phoenix liveview),
    description: "Utilities for integrating Ash with Phoenix and LiveView.",
    github_repo_handle: nil
  },
  %{
    name: "AshGraphQL",
    package: "ash_graphql",
    category: "api",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(graphql api),
    description: "GraphQL extension for exposing Ash resources via Absinthe.",
    github_repo_handle: nil
  },
  %{
    name: "AshJsonApi",
    package: "ash_json_api",
    category: "api",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(jsonapi rest),
    description: "JSON:API extension; build JSON:API-compliant endpoints from Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Jason",
    package: "ash_jason",
    category: "api",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(json encoding),
    description: "Implements Jason protocol support for Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash RPC",
    package: "ash_rpc",
    category: "api",
    official: false,
    kind: "extension",
    status: "experimental",
    tags: ~w(trpc rpc experimental),
    description:
      "Experimental: expose Ash resource actions over tRPC with Plug-compatible routing.",
    github_repo_handle: nil
  },

  # Auth & security
  %{
    name: "AshAuthentication",
    package: "ash_authentication",
    category: "auth",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(auth login passwordless),
    description: "Authentication extension for Ash: strategies, flows, and resource integration.",
    github_repo_handle: nil
  },
  %{
    name: "AshAuthentication Phoenix",
    package: "ash_authentication_phoenix",
    category: "auth",
    official: true,
    kind: "integration",
    status: "stable",
    tags: ~w(auth phoenix),
    description: "Phoenix and LiveView integration helpers for AshAuthentication.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Cloak",
    package: "ash_cloak",
    category: "auth",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(encryption cloak),
    description: "Encrypt and decrypt resource attributes seamlessly using Cloak.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Policy Access",
    package: "ash_policy_access",
    category: "auth",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(policies authorization),
    description: "Policy-based access helper; builds on Ash's authorization tooling.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Policy Authorizer",
    package: "ash_policy_authorizer",
    category: "auth",
    official: true,
    kind: "extension",
    status: "retired",
    tags: ~w(policies authorization),
    description: "Retired: early policy-based authorizer; functionality moved into core Ash.",
    github_repo_handle: nil
  },
  %{
    name: "Ash RBAC",
    package: "ash_rbac",
    category: "auth",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(rbac policies community),
    description: "Extension that simplifies applying policy-based access patterns via roles.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Rate Limiter",
    package: "ash_rate_limiter",
    category: "auth",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(rate-limit throttling),
    description: "Rate limiting extension for Ash, useful for APIs and public actions.",
    github_repo_handle: nil
  },

  # Domain behavior & business logic
  %{
    name: "Ash Archival",
    package: "ash_archival",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(soft-delete archival),
    description: "Implements archival (soft deletion) for resources with additional DSL support.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Paper Trail",
    package: "ash_paper_trail",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(audit versioning),
    description: "Audit log and versioning extension: track and query changes to resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash State Machine",
    package: "ash_state_machine",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(workflow states),
    description: "Defines state machines on resources, with transitions and guard logic.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Events",
    package: "ash_events",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(events event-sourcing),
    description: "Tracks changes to resources in a central event log with replay support.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Double Entry",
    package: "ash_double_entry",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(accounting finance),
    description: "Implements a customizable double-entry bookkeeping system using Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Money",
    package: "ash_money",
    category: "domain",
    official: true,
    kind: "extension",
    status: "stable",
    tags: ~w(money currency),
    description: "Adds money-related types and conveniences for handling monetary values.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Parental",
    package: "ash_parental",
    category: "domain",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(sti inheritance),
    description: "Adds single-table inheritance-style behavior to Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Outstanding",
    package: "ash_outstanding",
    category: "domain",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(protocol extensions),
    description: "Implements the Outstanding protocol for Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Translation",
    package: "ash_translation",
    category: "domain",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(i18n translations),
    description: "Provides translation management on Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Object IDs",
    package: "ash_object_ids",
    category: "domain",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(ids primary-key),
    description: "Use object-ID-style values as primary and foreign keys in Ash resources.",
    github_repo_handle: nil
  },

  # UI & admin
  %{
    name: "AshAdmin",
    package: "ash_admin",
    category: "ui",
    official: true,
    kind: "admin-ui",
    status: "stable",
    tags: ~w(admin liveview),
    description: "Super-admin UI for Ash applications, built with Phoenix LiveView.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Pyro",
    package: "ash_pyro",
    category: "ui",
    official: false,
    kind: "ui",
    status: "stable",
    tags: ~w(ui liveview),
    description: "Declarative UI toolkit for Ash, focused on LiveView-based interfaces.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Pyro Components",
    package: "ash_pyro_components",
    category: "ui",
    official: false,
    kind: "ui",
    status: "stable",
    tags: ~w(ui codegen),
    description: "Automatically renders UI for Ash resources using DSL-based configuration.",
    github_repo_handle: nil
  },
  %{
    name: "AshPagify",
    package: "ash_pagify",
    category: "ui",
    official: false,
    kind: "ui",
    status: "stable",
    tags: ~w(tables filtering pagination),
    description: "Adds full-text search, scoping, filtering, ordering, and pagination utilities.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Sitemap",
    package: "ash_sitemap",
    category: "ui",
    official: false,
    kind: "extension",
    status: "stable",
    tags: ~w(seo sitemaps),
    description: "Generates sitemaps from Ash resources.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Backpex",
    package: "ash_backpex",
    category: "ui",
    official: false,
    kind: "admin-ui",
    status: "early",
    tags: ~w(admin backpex),
    description: "Integration between Ash and Backpex admin panel, with a DSL for admin UIs.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Diagram",
    package: "ash_diagram",
    category: "ui",
    official: true,
    kind: "visualization",
    status: "stable",
    tags: ~w(diagrams visualization),
    description: "Generates interactive diagrams to visualize your Ash applications.",
    github_repo_handle: nil
  },

  # Observability & background jobs
  %{
    name: "AshOban",
    package: "ash_oban",
    category: "workflow",
    official: true,
    kind: "integration",
    status: "stable",
    tags: ~w(jobs oban),
    description: "Integrates Ash resources and actions with Oban background jobs.",
    github_repo_handle: nil
  },
  %{
    name: "Ash AppSignal",
    package: "ash_appsignal",
    category: "observability",
    official: true,
    kind: "integration",
    status: "stable",
    tags: ~w(apm monitoring),
    description: "AppSignal APM integration tailored for Ash-based applications.",
    github_repo_handle: nil
  },
  %{
    name: "OpenTelemetry Ash",
    package: "opentelemetry_ash",
    category: "observability",
    official: true,
    kind: "integration",
    status: "stable",
    tags: ~w(telemetry tracing),
    description: "OpenTelemetry integration for tracing Ash operations and requests.",
    github_repo_handle: nil
  },

  # Workflow & orchestration
  %{
    name: "Reactor",
    package: "reactor",
    category: "workflow",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(workflows graphs),
    description: "Asynchronous, graph-based execution engine; used heavily with Ash workflows.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Flow",
    package: "ash_flow",
    category: "workflow",
    official: true,
    kind: "extension",
    status: "soft-deprecated",
    tags: ~w(workflows legacy),
    description: "Soft-deprecated: earlier workflow composition tool for Ash resources.",
    github_repo_handle: nil
  },

  # Testing & fixtures
  %{
    name: "Ash Scenario",
    package: "ash_scenario",
    category: "testing",
    official: false,
    kind: "testing",
    status: "stable",
    tags: ~w(fixtures testing),
    description:
      "Reusable test data generation with dependency resolution and scenario composition.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Random Params",
    package: "ash_random_params",
    category: "testing",
    official: false,
    kind: "testing",
    status: "stable",
    tags: ~w(testing generators),
    description: "Generates random parameter sets for Ash resources (useful in tests).",
    github_repo_handle: nil
  },
  %{
    name: "Ash Mock",
    package: "ash_mock",
    category: "testing",
    official: false,
    kind: "testing",
    status: "stable",
    tags: ~w(mocking testing),
    description: "Helpers for mocking Ash behaviors in tests.",
    github_repo_handle: nil
  },

  # Tooling & DX
  %{
    name: "Ash Typescript",
    package: "ash_typescript",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(typescript codegen),
    description: "Generates TypeScript types and helpers from Ash resources and APIs.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Ops",
    package: "ash_ops",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(mix tasks),
    description: "Generates mix tasks for Ash actions to simplify operational workflows.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Query Builder",
    package: "ash_query_builder",
    category: "tooling",
    official: false,
    kind: "tooling",
    status: "stable",
    tags: ~w(queries helpers),
    description: "Helper library for building Ash.Query structures programmatically.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Req Opt",
    package: "ash_req_opt",
    category: "tooling",
    official: false,
    kind: "tooling",
    status: "stable",
    tags: ~w(dsl resource),
    description: "Shortcut DSL for declaring required/optional attributes and relationships.",
    github_repo_handle: nil
  },
  %{
    name: "Ash Profiler",
    package: "ash_profiler",
    category: "tooling",
    official: false,
    kind: "tooling",
    status: "stable",
    tags: ~w(profiling performance),
    description: "Performance profiling and optimization toolkit for Ash DSLs and compilation.",
    github_repo_handle: nil
  },
  %{
    name: "Ash AI",
    package: "ash_ai",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(ai llm),
    description: "Integrated LLM features for Ash apps (prompting, workflows, etc.).",
    github_repo_handle: nil
  },
  %{
    name: "Usage Rules",
    package: "usage_rules",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(guides rules),
    description: "Dev tool that gathers LLM usage rules from dependencies like Ash packages.",
    github_repo_handle: nil
  },
  %{
    name: "Igniter",
    package: "igniter",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(codegen project-setup),
    description:
      "Code generation and project patching framework, used heavily by Ash installers.",
    github_repo_handle: nil
  },
  %{
    name: "Spark",
    package: "spark",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(dsl compiler),
    description: "Generic DSL tooling used as the underlying engine for Ash's DSL.",
    github_repo_handle: nil
  },
  %{
    name: "Clarity",
    package: "clarity",
    category: "tooling",
    official: true,
    kind: "tooling",
    status: "stable",
    tags: ~w(introspection graphs),
    description:
      "Interactive introspection and visualization tool for Ash, Phoenix, and Ecto projects.",
    github_repo_handle: nil
  }
]

Enum.each(packages, fn attrs ->
  raw_tags = Map.get(attrs, :tags, [])
  tag_names = raw_tags |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == "")) |> Enum.uniq()

  # Ensure Tag records exist
  tags =
    Enum.map(tag_names, fn tag_name ->
      case Tag
           |> Ash.Query.filter(name == ^tag_name)
           |> Ash.read_one() do
        {:ok, %Tag{} = tag} ->
          tag

        {:ok, nil} ->
          Tag
          |> Ash.Changeset.for_create(:create, %{name: tag_name})
          |> Ash.create!()

        {:error, error} ->
          raise "Error looking up tag #{inspect(tag_name)}: #{inspect(error)}"
      end
    end)

  package_attrs =
    attrs
    |> Map.drop([:tags])
    # make sure we don't accidentally pass the list version
    |> Map.put_new(:github_repo_handle, Map.get(attrs, :github_repo_handle, nil))

  package =
    case Package
         |> Ash.Query.filter(package == ^Map.fetch!(attrs, :package))
         |> Ash.read_one() do
      {:ok, %Package{} = existing} ->
        existing
        |> Ash.Changeset.for_update(:update, package_attrs)
        |> Ash.update!()

      {:ok, nil} ->
        Package
        |> Ash.Changeset.for_create(:create, package_attrs)
        |> Ash.create!()

      {:error, error} ->
        raise "Error upserting package #{inspect(Map.get(attrs, :package))}: #{inspect(error)}"
    end

  Enum.each(tags, fn %Tag{id: tag_id} ->
    case PackageTag
         |> Ash.Query.filter(package_id == ^package.id and tag_id == ^tag_id)
         |> Ash.read_one() do
      {:ok, %PackageTag{}} ->
        :ok

      {:ok, nil} ->
        PackageTag
        |> Ash.Changeset.for_create(:create, %{package_id: package.id, tag_id: tag_id})
        |> Ash.create!()

      {:error, error} ->
        raise "Error creating package_tag for #{inspect(package.package)}:#{inspect(tag_id)} - #{inspect(error)}"
    end
  end)
end)

IO.puts("Seeded #{length(packages)} packages with tags.")
