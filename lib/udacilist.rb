class UdaciList
  attr_reader :title, :items

  def initialize(options = {})
    options[:title] ? @title = options[:title] : @title = 'Untitled List'
    @items = []
  end

  def add(type, description, options = {})
    case type.downcase
    when 'todo'
      @items.push TodoItem.new(description, options)
    when 'event'
      @items.push EventItem.new(description, options)
    when 'link'
      @items.push LinkItem.new(description, options)
    else
      fail UdaciListErrors::InvalidItemType, 'Type = ' + type
    end
  end

  def delete(index)
    if index > @items.size + 1
      fail UdaciListErrors::IndexExceedsListSize, 'Index = ' + index.to_s
    end
    @items.delete_at(index - 1)
  end

  # prints the full list of list items
  def all
    puts '-' * @title.length
    puts @title
    puts '-' * @title.length

    print_group(TodoItem, ['', 'Todo', 'Due', 'Priority'])
    print_group(EventItem, ['', 'Event', 'Start', 'End'])
    print_group(LinkItem, ['', 'Link', 'Site Name'])
  end

  # print one type of item, formatted in a table
  def print_group(type, headings)
    rows = []
    @items.each_with_index do |item, i|
      rows << [i + 1] + item.line if item.instance_of?(type)
    end
    table = Terminal::Table.new(headings: headings,
                                rows: sort_lines(type, rows))
    puts table
  end

  # sort the lines by date or alphabetically for links
  def sort_lines(type, rows)
    if type == TodoItem || type == EventItem
      rows.sort { |rowa, rowb| rowa[2] <=> rowb[2] }
    else
      rows.sort { |rowa, rowb| rowa[1] <=> rowb[1] }
    end
  end

  # return a list containing the objects of a specific type
  def filter(type)
    list = @items.select { |item| item.class.class_name == type }
    if list.empty?
      fail UdaciListErrors::NoItems, 'No items of type: ' + type
    else
      list
    end
  end
end
