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
    if index < 1
      fail UdaciListErrors::IndexInvalid, 'Index = ' + index.to_s
    end
    @items.delete_at(index - 1)
  end

  # prints the full list of list items
  def all
    resort_array
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
    table = Terminal::Table.new(headings: headings, rows: rows)
    puts table
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

  # resort array
  def resort_array
    new_list = get_sorted_list(TodoItem)
    new_list += get_sorted_list(EventItem)
    new_list += get_sorted_list(LinkItem)
    @items = new_list
  end

  # get sorted list of a item type
  def get_sorted_list(type)
    temp_array = @items.select { |item| item.instance_of?(type) }
    case
    when type == TodoItem
      temp_array.sort! { |i, j| i.due.to_s <=> j.due.to_s }
    when type == EventItem
      temp_array.sort! { |i, j| i.start_date.to_s <=> j.start_date.to_s }
    when type == LinkItem
      temp_array.sort! { |i, j| i.site_name <=> j.site_name }
    end
    temp_array
  end
end
