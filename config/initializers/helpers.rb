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
    tags = article.metadata[:page]['tags']
    if tags
      first_tag = tags.split(',')[0]

      link_to capture(&block), tag_path(first_tag), class: 'tag'
    end
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

  def article_demos(article, link_class='nil')
    article.data.demos.split(',').map do |demo|
      text, link = *demo.split('|').map{|item| item.strip }
      link_to text, "/demos/#{link}", class: link_class, target: '_blank'
    end.join(' ')
  end

  def article_references(article, link_class=nil)
    article.data.references.split(',').each_with_index.map do |reference, i|
      link_to "Reference #{i + 1}", reference, class: link_class, target: '_blank'
    end.join(' ')
  end

  def tag_counts
    blog.tags.map do |tag, articles|
      [tag, articles.size]
    end.sort{|a, b| a.last <=> b.last  }.reverse.take_while{|tag| tag.last > 1 }
  end

  def article_links(article)
    %w(downloads demos references).map do |data_item|
      if article.data.send(data_item).present?
        send("article_#{data_item}", article, 'btn btn-primary')
      end
    end.compact
  end

  def link_to_if(condition, name, options = {}, html_options = {}, &block)
    if condition
      link_to(name, options, html_options)
    else
      if block_given?
        block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
      else
        name.html_safe
      end
    end
  end
end
