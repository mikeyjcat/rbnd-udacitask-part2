class LinkItem
  include Listable
  attr_reader :description, :site_name

  def initialize(url, options = {})
    @description = url
    @site_name = options[:site_name] ? options[:site_name] : ''
  end

  def line
    [@description, @site_name]
  end

  def self.class_name
    'link'
  end
end
