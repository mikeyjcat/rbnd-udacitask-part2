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

  def all
    puts '-' * @title.length
    puts @title
    puts '-' * @title.length

    print_group(TodoItem, ['', 'Todo', 'Due', 'Priority'])
    print_group(EventItem, ['', 'Event', 'Start', 'End'])
    print_group(LinkItem, ['', 'Link', 'Site Name'])
  end

  def print_group(type, headings)
    rows = []
    @items.each_with_index do |item, i|
      rows << [i + 1] + item.line if item.instance_of?(type)
    end
    table = Terminal::Table.new(headings: headings, rows: sort_lines(type, rows))
    puts table
  end

  def sort_lines(type, rows)
    if type == TodoItem or type == EventItem
      rows.sort { |rowa, rowb| rowa[2] <=> rowb[2] }
    else
      rows
    end
  end      

  def filter(type)
    list = @items.select do |item|
      case
      when item.instance_of?(EventItem)
        true if type == 'event'
      when item.instance_of?(TodoItem)
        true if type == 'todo'
      when item.instance_of?(LinkItem)
        true if type == 'link'
      else
        false
      end
    end
    fail UdaciListErrors::NoItems, 'No items of type: ' + type if list.empty?
    return list
  end
end
