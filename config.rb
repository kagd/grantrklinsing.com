require 'font-awesome-sass'

# Load configuration files
project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/config/environment/*') {|file| binding.eval File.read(file)}
Dir.glob(project_root + '/config/initializers/*') {|file| binding.eval File.read(file)}

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end
