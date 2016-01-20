class TodoItem
  include Listable
  attr_reader :description, :due, :priority
  PRIORITIES = ['high', 'medium', 'low', nil]

  def initialize(description, options = {})
    @description = description
    @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]

    if PRIORITIES.include? options[:priority]
      @priority = options[:priority]
    else
      fail UdaciListErrors::InvalidPriority, 'Priority = ' + options[:priority]
    end
  end

  def line
    [@description, format_date(@due), format_priority(@priority)]
  end

  def self.class_name
    'todo'
  end
end
