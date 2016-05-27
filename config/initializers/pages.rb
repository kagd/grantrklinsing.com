require 'pathname'

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

with_layout false do
  page "/feed.xml"

  ###
  # Angular Templates
  # - automatically add pages under the /templates dir
  ###
  Dir.glob(project_root + '/source/templates/**/*.slim').each do |file|
    matches = file.match('.+templates\/([\w\/]+)')
    path = matches[1]
    page "/templates/#{ path }.html"
  end
end
