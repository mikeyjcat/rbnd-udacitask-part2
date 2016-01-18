module Listable
  def format_priority(priority)
    case priority
    when 'high'
      ' ⇧'.colorize(:red)
    when 'medium'
      ' ⇨'.colorize(:yellow)
    when 'low'
      ' ⇩'.colorize(:green)
    else
      ''
    end
  end

  def format_date(date)
    date ? date.strftime('%D') : ''
  end
end
