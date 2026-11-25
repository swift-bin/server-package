struct ServerPackageDependency {
    enum DefaultState {
        case enabled
        case commented
    }

    let symbol: String
    let repo: String
    let package: String
    let product: String
    let state: DefaultState

    init(
        _ name: String,
        state: DefaultState = .commented
    ) {
        self.symbol = name
        self.repo = name
        self.package = name
        self.product = name
        self.state = state
    }

    init(
        symbol: String,
        repo: String,
        package: String? = nil,
        product: String? = nil,
        state: DefaultState = .commented
    ) {
        self.symbol = symbol
        self.repo = repo
        self.package = package ?? repo
        self.product = product ?? package ?? repo
        self.state = state
    }

    var organization: ServerPackageOrganization {
        ServerPackageOrganization.owning(
            repo
        )
    }
}

struct ServerPackageOrganization: Hashable {
    let owner: String

    /// Namespace symbol in generated manifests: `swift-lco` → `swift_lco`.
    var symbol: String {
        owner.replacingOccurrences(
            of: "-",
            with: "_"
        )
    }

    /// Catalog type name in generated manifests: `swift-lco` → `SwiftLco`.
    var catalogType: String {
        owner
            .split(separator: "-")
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .joined()
    }

    static let fallback = ServerPackageOrganization(
        owner: "leviouwendijk"
    )

    static func owning(
        _ repo: String
    ) -> ServerPackageOrganization {
        owners[repo].map {
            ServerPackageOrganization(owner: $0)
        } ?? fallback
    }

    /// GitHub organization per repository; repositories not listed stay on `leviouwendijk`.
    private static let owners: [String: String] = {
        let groups: [String: [String]] = [
            "swift-agentic": [
                "Agentic", "AgenticAccounting", "AgenticAdapters", "AgenticApplication",
                "AgenticDomains", "AgenticHost", "AgenticIO", "AgenticInterfaces",
                "AgenticMedia", "AgenticPDF", "AgenticProviders", "AgenticRuntime",
                "AgenticServer",
            ],
            "swift-tooling": [
                "Documentation", "Executable", "Guidelines", "GuidelinesDiagnostics",
                "GuidelinesSearch", "SwiftSemantics", "TestFlows", "Testing",
            ],
            "swift-dsl": [
                "CSS", "DSL", "HTML", "ICS", "JS", "PSQL", "SQLite",
            ],
            "swift-sdk": [
                "Apple", "AWSConnector", "Bunq", "Google", "Mail", "PayNL",
                "PostgresConnector", "UniFi",
            ],
            "swift-webc": [
                "Auth", "Components", "Constructors", "HTTP", "MarkupComponents",
                "ProtocolComponents", "Server", "ServerWeb", "Surfaces", "Vaporized",
                "WebComponents",
            ],
            "swift-langs": [
                "Grammar", "Lexing", "Parsers", "Parsing", "Syntax", "Tokens",
            ],
            "lco-langs": [
                "Frame",
            ],
            "swift-nvim": [
                "Swim", "SwimInterpreter", "SwimIO", "SwimTerminal",
            ],
            "depaix-labs": [
                "Accounting", "Banking", "Commerce", "Cynology", "Picker",
            ],
            "swift-lco": [
                "Allocators", "ANSI", "Arguments", "Assets", "Atomos", "Capture",
                "Clipboard", "Codecs", "Compositions", "Concatenation", "Cryptography",
                "Difference", "Drawingboard", "Errors", "Excerpt", "Extensions",
                "FileParsers", "FileTypes", "Fuzzy", "Graphical", "Images",
                "Implementations", "Indentation", "Interfaces", "IO", "LanguageModels",
                "Loggers", "MacActor", "Macros", "Matching", "Math", "Media", "Methods",
                "Milieu", "Musica", "Observability", "Partition", "Path", "PDF",
                "Position", "Primitives", "Processes", "Ranking", "Readers", "References",
                "Registry", "Reporting", "Schema", "Search", "Selection", "Sensitivity",
                "Strings", "Structures", "Terminal", "Timecode", "Transcribe",
                "Variables", "Version", "ViewComponents", "ViewPrimitives", "Workspace",
                "Writers",
            ],
        ]

        var owners: [String: String] = [:]
        for (owner, repos) in groups {
            for repo in repos {
                owners[repo] = owner
            }
        }
        return owners
    }()
}

struct ServerPackageDependencyGroup {
    let title: String?
    let dependencies: [ServerPackageDependency]
}

enum ServerPackageDependencyCatalog {
    static let core = ServerPackageDependencyGroup(
        title: nil,
        dependencies: [
            .init("HTTP", state: .enabled),
            .init("Server", state: .enabled),
            .init("Milieu", state: .enabled),
            .init("Loggers", state: .enabled),
        ]
    )

    static let implementationDefaults = ServerPackageDependencyGroup(
        title: "implementation defaults",
        dependencies: [
            .init("Authentication"),
            .init("Cryptography"),
            .init("PostgresConnector"),
            .init("IO"),
            .init("Processes"),
            .init("Assets"),
            .init("Media"),
            .init("Agentic"),
            .init("AgenticAdapters"),
            .init("AgenticDomains"),
            .init("AgenticInterfaces"),
            .init("TestFlows"),
        ]
    )

    static let optional = ServerPackageDependencyGroup(
        title: "other libraries",
        dependencies: [
            .init("Accounting"),
            .init("Allocators"),
            .init("ANSI"),
            .init("Arguments"),
            .init("AWSConnector"),
            .init("Capture"),
            .init("Clipboard"),
            .init("Commerce"),
            .init("Compositions"),
            .init("Concatenation"),
            .init("Constructors"),
            .init("CSS"),
            .init("Cynology"),
            .init("Difference"),
            .init("DSL"),
            .init("Economics"),
            .init("Executable"),
            .init("Extensions"),
            .init("FileParsers"),
            .init("FileTypes"),
            .init("Fuzzy"),
            .init("Graphical"),
            .init("HTML"),
            .init("ICS"),
            .init("Implementations"),
            .init("Indentation"),
            .init("Interfaces"),
            .init("JS"),
            .init("Mail"),
            .init("Matching"),
            .init("Methods"),
            .init("Musica"),
            .init("Parsers"),
            .init("Parsing"),
            .init("Partition"),
            .init("Path"),
            .init("plate"),
            .init("Position"),
            .init("Primitives"),
            .init("ProtocolComponents"),
            .init("PSQL"),
            .init("Ranking"),
            .init("Readers"),
            .init("Registry"),
            .init("Selection"),
            .init("Storable"),
            .init("Strings"),
            .init("Terminal"),
            .init("Tokens"),
            .init("Variables"),
            .init("Version"),
            .init("ViewComponents"),
            .init("WebComponents"),
            .init("Writers"),
        ]
    )

    static let minimal = [
        core,
    ]

    static let full = [
        core,
        implementationDefaults,
        optional,
    ]

    static func flattened(
        _ groups: [ServerPackageDependencyGroup]
    ) -> [ServerPackageDependency] {
        groups.flatMap(\.dependencies)
    }
}

enum ServerPackageDependencyRenderer {
    static func dynamicPackages(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".\(dependency.organization.symbol).\(dependency.symbol),"
        }
    }

    static func dynamicProducts(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        dynamicPackages(
            groups,
            indentation: indentation
        )
    }

    static func prosePackages(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".package(url: \"https://github.com/\(dependency.organization.owner)/\(dependency.repo).git\", branch: \"master\"),"
        }
    }

    static func proseProducts(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int
    ) -> String {
        renderGroups(
            groups,
            indentation: indentation
        ) { dependency in
            ".product(name: \"\(dependency.product)\", package: \"\(dependency.package)\"),"
        }
    }

    /// Generated-manifest pieces for every organization the dependencies live in.
    struct DynamicOrganizations {
        /// `static let swift_lco = SwiftLco()` lines for `enum Libs`.
        let libs: String
        /// One `struct SwiftLco { let IO = Deps.Ref("IO") … }` per organization.
        let catalogs: String
        /// `static var swift_lco: Deps.Packages<SwiftLco>` members for `extension Package.Dependency`.
        let packages: String
        /// `static var swift_lco: Deps.Products<SwiftLco>` members for `extension Target.Dependency`.
        let products: String
    }

    static func dynamicOrganizations(
        _ groups: [ServerPackageDependencyGroup]
    ) -> DynamicOrganizations {
        let dependencies = ServerPackageDependencyCatalog.flattened(groups)
        var organizations: [ServerPackageOrganization] = []
        for dependency in dependencies where !organizations.contains(dependency.organization) {
            organizations.append(dependency.organization)
        }

        let libs = organizations
            .map { "    static let \($0.symbol) = \($0.catalogType)()" }
            .joined(separator: "\n")

        let catalogs = organizations
            .map { organization in
                let refs = dynamicCatalog(
                    dependencies.filter { $0.organization == organization },
                    indentation: 4
                )
                return "struct \(organization.catalogType) {\n\(refs)\n}"
            }
            .joined(separator: "\n\n")

        func members(
            _ kind: String
        ) -> String {
            organizations
                .map { organization in
                    """
                        static var \(organization.symbol): Deps.\(kind)<\(organization.catalogType)> {
                            .init(
                                github: .init(owner: "\(organization.owner)"),
                                catalog: Libs.\(organization.symbol)
                            )
                        }
                    """
                }
                .joined(separator: "\n\n")
        }

        return DynamicOrganizations(
            libs: libs,
            catalogs: catalogs,
            packages: members("Packages"),
            products: members("Products")
        )
    }

    static func dynamicCatalog(
        _ dependencies: [ServerPackageDependency],
        indentation: Int
    ) -> String {
        let prefix = String(
            repeating: " ",
            count: indentation
        )

        return dependencies
            .map { dependency in
                if dependency.symbol == dependency.repo,
                   dependency.package == dependency.repo,
                   dependency.product == dependency.repo {
                    return "\(prefix)let \(dependency.symbol) = Deps.Ref(\"\(dependency.repo)\")"
                }

                return """
                \(prefix)let \(dependency.symbol) = Deps.Ref(
                \(prefix)    repo: "\(dependency.repo)",
                \(prefix)    package: "\(dependency.package)",
                \(prefix)    product: "\(dependency.product)"
                \(prefix))
                """
            }
            .joined(
                separator: "\n"
            )
    }

    private static func renderGroups(
        _ groups: [ServerPackageDependencyGroup],
        indentation: Int,
        line: (ServerPackageDependency) -> String
    ) -> String {
        let prefix = String(
            repeating: " ",
            count: indentation
        )

        return groups
            .map { group in
                var lines: [String] = []

                if let title = group.title {
                    lines.append(
                        "\(prefix)// \(title)"
                    )
                }

                lines.append(
                    contentsOf: group.dependencies.map { dependency in
                        let comment = switch dependency.state {
                        case .enabled:
                            ""
                        case .commented:
                            "// "
                        }

                        return "\(prefix)\(comment)\(line(dependency))"
                    }
                )

                return lines.joined(
                    separator: "\n"
                )
            }
            .joined(
                separator: "\n\n"
            )
    }
}
