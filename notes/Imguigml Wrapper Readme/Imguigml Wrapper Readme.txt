ImguiGML Wrapper Readme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
a. Installation
b. Features
c. Usage
d. Settings
e. Search


a. Installation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This is a "wrapper" for the `imgui` object included with ImguiGML.  To install it, set objImguiWrapper as
the child of `imgui` and include it in your project the same way you would normally use it.  A common
approach is to use an initialization script with the line:

room_instance_add( room_first, 0, 0, objImguiWrapper );

You can verify that it has been properly installed and included if you see a menu bar with a "File" menu,
as well as an entry in the output log:

objImguiWrapper :: Initialized.  Imgui 1.83 in use.

The version shown will depend on the version of ImguiGML that is being used, but should you see both of
these things you are ready to start utilizing the wrapper.

b. Features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
	

c. Usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Once setup, you can open windows or attach menubars by creating scripts (see the relevant notes) as
needed.  A key behavior of the wrapper is that it attempts to contain all of the imgui data in a single
place which allows it to be cleanly removed when developer tools should not be present (such as a release
build).  Nevertheless, it is still possible to create dependencies.  It is a best practice to avoid
calling `imgui` directly from any code that is not expected to be present when `imgui` is.  There are
two convenience functions that can be safely called when `imgui` is not present:

imguigml_wrapper_add_menu()
imguigml_wrapper_inspect()

These functions will do nothing when `imgui` hasn't been instantiated.  You can also avoid hard
dependencies by using `with( imgui )` to encompass any code that expects `imgui` to exist.  Because
`imgui` and the wrapper have a performance overhead, it is desirable to not include it in release
builds.


d. Settings
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The settings are provided to make it easier to load and save debug-centric variables.  By default all
read settings will end up in the `Settings` window under the File menu.  It should be noted that a value
*must* be read before it will show up in the settings menu!  For menus this is generally done by reading
them during the constructor function, but if you have personal settings you'd like loaded on startup they'll
need to be read during a Game Start or Create event.

Settings is accessed via:
	imgui.settings


Methods attached:
	read( name, value, tooltip ) -> Reads a setting from the settings file, declares it if it doesn't exist.
	set( name, value ) -> Changes a setting to the given value.  Returns the set value to make variable
		management simpler.
	on_change( name, function ) -> Binds a function that will be called when a setting changes. The
		function should have the format, 


Argument descriptions:
	name	-> The name is broken up between ## and must be unique!  If it is not, it will simply overwrite
		or read from whatever setting it shares a name with.  To reduce the potential of clashes, and also
		aid in categorization, you can include a category after ## in the name, ie:
			"My Setting##My Category"
		
			This will place My Setting under My Category in the settings menu.  You must use this full
			name with set as well!
		
	value	-> While you can use any value type that JSON will support, including structs, note that only
		booleans, numbers and strings will appear in the settings menu.
	
	tooltip	-> This is the tooltip that will appear while hovering over the option in the Settings menu.  If
		you do not wish to use this behavior, either omit the argument or use "".


e. Search
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The search filter is used to make it easier to set up filterable lists.  The Goto... section of the File
menu makes use of this feature.  It creates a text input box, a search button and a reset button.  You
must provide the array of things to filter, and by default it will filter it by the search term.  It is
possible to modify the filter behavior by providing a kwargs struct which contains the necessary overrides.

Search is accessed via:
	imgui.search


Methods attached:
	filter( array, kwargs ) -> Returns a filtered list.
	reset( key ) -> Resets the filtered list.  Normally called when Reset is clicked.


Argument descriptions:
	array	-> The array that you want filtered.  Remember, this function returns a _filtered_ array, so
		you should not catch this in the original array you want filtered.  Instead, catch the return in
		a temporary variable.
	
	kwargs	-> By default the filter will match any element that contains the search phrase regardless of
		capitalization.  You can override this behavior by providing a struct with one or more of the
		following kwargs.
			key : The search filter uses a reserved space for caching information.  If you are using multiple
				search bars this may clash or cause unexpected results.  Providing a unique key will create
				a new space for this search to take place.
			compare : This is a method in the form function( text, compare ).  When this function returns
				true the comparison is considered a success.  The default function is:
					return string_pos( text, compare ) > 0
			modify : This is a method in the form function( text ).  It will be passed the text value
				and use the return.  By default it uses `string_lower`.
