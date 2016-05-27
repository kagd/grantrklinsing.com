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
  ###
  page "/templates/diablo/diablo_component.html"
  page "/templates/github/github_component.html"
  page "/templates/tags_actionsheet/tags_actionsheet_component.html"
end
