package kindsys

// The schema interfaces defined in this file are meta-schemas. They are shared
// contracts between the producers (composable kinds, defined in Grafana
// plugins) and consumers (core and custom Grafana kinds) of composable schemas.
//
// This contract is similar to an interface in most programming languages:
// producer and consumer implementations depend only on the schema interface
// definition, rather than the details of any particular implementation. This
// allows producers and consumers to be loosely coupled, while keeping an
// explicit contract for composition of sub-schemas from producers into the
// consumer schemas that want to use them.
//
// Schema interfaces allow schema composition to be broken down into a series of
// simple "what," "which," and "how" questions:
//
//  - "What" is the subschema to be composed?
//  - "How" should subschema(s) be composed into another schema to produce a unified result schema?
//  - "Which" subset of known composable subschemas ("whats") should be provided in composition ("how")?
//
// On the producer side, Grafana plugin authors may provide Thema lineages
// within #Composable kinds declared in .cue files adjacent to their
// plugin.json, following a pattern (see
// github.com/grafana/grafana/pkg/plugins/pfs.#GrafanaPlugin.composableKinds)
// corresponding to the name of the schema interface. Each such definition is
// an answer to "what."
//
// On the consumer side, any #CoreStructured or #CustomStructured kind author
// can choose to define a standard Thema composition slot in its contained
// lineage that uses one of these schema interfaces as its meta-schema. The
// slot specification in Thema answers "how", for that kind.
//
// Composable kinds declared by a plugin are parsed and validated by Grafana's
// plugin system when a plugin is installed. This gives each Grafana instance a
// set of all known #Composable kinds ("whats"), which can be narrowed into the
// subsets ("which") that each known #CoreStructured or #CustomStructured can
// consume. These subsets are injected dynamically into the consumers, resulting
// in the actual schema
//
// For example, in the Thema lineage for the dashboard #CoreStructured kind:
//  - There is a slot named `panelcfg`
//  - It is constrained to accept only Thema lineages following the `panelcfg` schema interface
//  - The composition logic specifies that the `panelcfg.PanelOptions` from each lineage provided
//    to the dashboard lineage be one possibility for `panels[].options`
//
// (TODO actual implementation is pending https://github.com/grafana/thema/issue/8)
//
// Thus, the dashboard schema used for validation by any particular Grafana instance
// can tell the user if a particular dashboard with a `timeseries` panel has invalid
// values for `panels[].options`, even though neither the dashboard core kind, nor the
// the timeseries composable kind, are directly aware of (import) each other.

// A SchemaInterface defines a single Grafana schema interface.
#SchemaInterface: {
	// name is the unique identifier of the schema interface.
	//
	// Often used to provide namespacing of schema interface implementations
	// in places where implementations must be enumerated, such as:
	//  - In-memory indexes in the Grafana backend
	//  - Documentation URLs
	//  - Parent directory paths or names in generated code
	name: string & =~"^[a-z]{1,20}$"

	// interface is the body of the SchemaInterface - the actual meta-schema that
	// forms the shared contract between consumers (core & custom kind lineages)
	// and producers (composable kind lineages).
	interface: {...}

	// Whether lineages implementing this are considered "grouped" or not. Generally
	// this refers to whether an e.g. JSON object is ever expected to exist that
	// corresponds to the whole schema, or to top-level fields within the schema.
	//
	// TODO see https://github.com/grafana/thema/issues/62
	//
	// The main effect is whether code generation should produce one type that represents
	// the root schema for lineages, or only produce types for each of the top-level fields
	// within the schema.
	group: bool | *true
}

// The canonical list of all Grafana schema interfaces.
schemaInterfaces: [string]: #SchemaInterface
schemaInterfaces: {
	panelcfg: {
		interface: {
			// Defines plugin-specific options for a panel that should be persisted. Required,
			// though a panel without any options may specify an empty struct.
			//
			// Currently mapped to #Panel.options within the dashboard schema.
			PanelOptions: {...}

			// Plugin-specific custom field properties. Optional.
			//
			// Currently mapped to #Panel.fieldConfig.defaults.custom within the dashboard schema.
			PanelFieldConfig?: {...}
		}

		// grouped b/c separate non-cross-referring elements always occur together in larger structure (panel)
		group: true
	}
	queries: {
		// joinSchema is a struct template enforcing that if a queryType field exists,
		// it must have the same string value as the declaring key
		interface: [QT=string]: {
			queryType?: QT
		}

		// grouped b/c separate, non-cross-referring elements are actually themselves each impls of the concept
		// and it avoids us having to put more levels in the slot system (uggghhh)
		group: true
	}
	dscfg: {
		interface: {
			// Normal datasource configuration options.
			Options: {...}
			// Sensitive datasource configuration options that require encryption.
			SecureOptions: {...}
		}

		// group b/c separate, non-cross-referring elements have diff runtime representation due to encryption
		group: true
	}
}
