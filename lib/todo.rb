class TodoItem
  include Listable
  attr_reader :description, :due, :priority
  PRIORITIES = ['high', 'medium', 'low', nil]

  def initialize(description, options = {})
    @description = description
    @due = options[:due] ? Date.parse(options[:due]) : options[:due]
    
    if PRIORITIES.include? options[:priority]
      @priority = options[:priority]
    else
      fail UdaciListErrors::InvalidPriority, 'Priority = ' + options[:priority]
    end
  end

  def details
    format_description(@description) + 'due: ' +
      format_date(@due) +
      format_priority(@priority)
  end
end
