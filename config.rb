require 'font-awesome-sass'

###
# Blog settings
###

Time.zone = "Mountain Time (US & Canada)"

activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  blog.prefix = "articles"

  # blog.permalink = "{year}/{month}/{day}/{title}.html"
  # Matcher for blog source files
  blog.sources = "/{year}/{month}-{day}-{title}.html"
  # blog.taglink = "tags/{tag}.html"
  # blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  # blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"
end

# activate :spellcheck

activate :deploy do |deploy|
  deploy.method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  deploy.branch   = 'master' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

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

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def fa_icon(icon, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "fa fa-#{icon}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end

  def article_image(article)
    tag = article.metadata[:page]['tags'].split(',')[0]
    tag_image tag
  end

  def tag_image(tag)
    image_name = "#{ tag }.svg"
    unless File.exist? File.expand_path("source/images/#{ image_name }")
      image_name = 'logo.svg'
    end
    image_tag image_name
  end

  def tag_link_from_article(article, &block)
    first_tag = article.metadata[:page]['tags'].split(',')[0]

    link_to capture(&block), tag_path(first_tag)
  end

  def tag_path(tag)
    "/articles/tags/#{tag}.html"
  end

  def tag_link(tag, &block)
    link_to capture(&block), tag_path(tag)
  end

  def article_downloads(article, link_class=nil)
    article.data.downloads.split(',').map do |download|
      text, link = *download.split('|').map{|item| item.strip }
      link_to text, "../../#{link}", class: link_class, target: '_blank'
    end.join(' ')
  end

  def article_demos(article, link_class=nil)
    article.data.demos.split(',').map do |demo|
      text, link = *demo.split('|').map{|item| item.strip }
      link_to text, "/demos/#{link}", class: link_class, target: '_blank'
    end.join(' ')
  end

  def tag_counts
    blog.tags.map do |tag, articles|
      [tag, articles.size]
    end.sort{|a, b| a.last <=> b.last  }.reverse.take_while{|tag| tag.last > 1 }
  end
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, prettify: true

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
