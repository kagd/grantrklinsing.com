# don't allow attributes to be defined within curly braces
# Mainly setup to deal with angular template interpolation
Slim::Engine.set_options({attr_list_delims: {'(' => ')', '[' => ']'}})
