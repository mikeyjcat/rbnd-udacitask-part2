module Listable
  def format_description(description)
    "#{description}".ljust(25)
  end

  def format_priority(priority)
    case priority
    when 'high'
      ' ⇧'
    when 'medium'
      ' ⇨'
    when 'low'
      ' ⇩'
    else
      ''
    end
  end

  def format_date(start_date, end_date = nil)
    dates = start_date.strftime('%D') if start_date
    dates << ' -- ' + end_date.strftime('%D') if end_date
    dates ? dates : 'N/A'
  end
end
