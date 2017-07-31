<ScenarioMap
	Release = "1.0"
	Description = "">
	<Scenario
		ScenarioName = "Toggle Link"
		TclScriptFile = ".\..\scenarios\lnktoggl.tcl"
		ScenarioDesc = ""
		TclSACommand = "0"
		ScenarioType = "Map">
	/>
	<Scenario
		ScenarioName = "Link Up"
		TclScriptFile = ".\..\scenarios\lnkupmap.tcl"
		ScenarioDesc = ""
		TclSACommand = "0"
		ScenarioType = "Map">
	/>
	<Scenario
		ScenarioName = "Link Down"
		TclScriptFile = ".\..\scenarios\lnkdnmap.tcl"
		ScenarioDesc = ""
		TclSACommand = "0"
		ScenarioType = "Map">
	/>
	<Scenario
		ScenarioName = "Increase Utilization"
		TclScriptFile = ".\..\scenarios\utilup.tcl"
		ScenarioDesc = ""
		TclSACommand = "0"
		ScenarioType = "Device">
		<LabelSet
			Lindex = "0"
			InputType = "0"
			Label = "Interface Index"
			Value = "1"
		/>
		<LabelSet
			Lindex = "1"
			InputType = "0"
			Label = "Trap Manager IP"
			Value = "1.1.1.1"
		/>
	/>
	<Scenario
		ScenarioName = "Decrease Utilization"
		TclScriptFile = ".\..\scenarios\utildn.tcl"
		ScenarioDesc = ""
		TclSACommand = "0"
		ScenarioType = "Device">
		<LabelSet
			Lindex = "0"
			InputType = "0"
			Label = "Interface Index"
			Value = "1"
		/>
		<LabelSet
			Lindex = "1"
			InputType = "0"
			Label = "Trap Manager IP"
			Value = "1.1.1.1"
		/>
	/>
</ScenarioMap>
