# ImguiGMLWrapper
ImguiGML is already fairly easy, but there are certain tasks that are commonplace, and may have to be done
repeatedly in a single project.  This wrapper provides injection points for both the menubar, individual
windows and modals, simple preferences that persist between runs, and several convenience features.  Most
features are accessed through `imgui` and includes the following domains:

imgui.menubar -> Used to add new menus to the menu bar.
	add( name, function ) -> adds a new item to the menubar
	remove( name ) -> removes an existing item from the menubar


imgui.window -> Used to open/close new windows.
	open( name, function ) -> opens a new window
	close( name ) -> closes the specified window
	is_open( name ) -> returns true if the named window is open


imgui.modals -> Used to open modals.
	confirm( name, text, yes, no ) -> Creates a "yes/no" style confirmation modal.


imgui.inspector -> Used to modify the inspector.
	set_default( index, variables... ) -> Adds the default variables to the given object index.


imgui.mouse -> Contains the mouse state against imgui inputs, will be false if imgui is using the mouse.
	left	-> returns the state of the left mouse button
	right	-> returns the state of the right mouse button


imgui.settings -> For reading and writing savable variables.
	read( name, default, tooltip ) -> Reads the given value *and* sets up the value in the settings menu.
	set( name, value ) -> Sets the given value.
	on_change( name, function ) -> Runs the given function when the setting changes.
	

imgui.search -> A simple way to set up filterable search terms.
	filter( array, kwargs ) -> Creates a search bar which will filter the given list, returns the filtered list.
	reset( name ) -> If multiple search bars are being used, name will specify which one to reset.
	
