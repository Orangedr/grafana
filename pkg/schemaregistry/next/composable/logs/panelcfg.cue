// Code generated - EDITING IS FUTILE. DO NOT EDIT.
//
// Generated by:
//     public/app/plugins/gen.go
// Using jennies:
//     PluginSchemaRegistryJenny
//
// Run 'make gen-cue' from repository root to regenerate.

import (
	"github.com/grafana/kindsys"
	"github.com/grafana/grafana/packages/grafana-schema/src/common"
)

kindsys.Composable & {
	maturity:        "experimental"
	name:            "Logs" + "PanelCfg"
	schemaInterface: "PanelCfg"
	lineage: {
		seqs: [{
			schemas: [{
				PanelOptions: {
					showLabels:         bool
					showCommonLabels:   bool
					showTime:           bool
					wrapLogMessage:     bool
					prettifyLogMessage: bool
					enableLogDetails:   bool
					sortOrder:          common.LogsSortOrder
					dedupStrategy:      common.LogsDedupStrategy
				} @cuetsy(kind="interface")
			}]
		}]
		name: "Logs" + "PanelCfg"
	}
}