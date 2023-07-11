module TimeHelper
  def format_time_left(time_left, long = true)
    time_left = time_left.to_i || 0

    months = (time_left / 1.month).floor
    weeks = ((time_left % 1.month) / 1.week).floor
    days = ((time_left % 1.week) / 1.day).floor
    hours = ((time_left % 1.day) / 1.hour).floor
    minutes = ((time_left % 1.hour) / 1.minute).floor
    seconds = (time_left % 1.minute).floor

    time_left_string = ''

    time_left_string += "#{pluralize(months, 'mês', 'meses')}, " if long
    time_left_string += "#{pluralize(weeks, 'semana', 'semanas')}, " if long
    time_left_string += "#{pluralize(days, 'dia', 'dias')}, "
    time_left_string += "#{pluralize(hours, 'hora', 'horas')}, "
    time_left_string += "#{pluralize(minutes, 'minuto', 'minutos')}, "
    time_left_string += "#{pluralize(seconds, 'segundo', 'segundos')}"

    values = time_left_string.split(', ')

    values.map do |value|
      v = value.split(' ')
      "<div class='countdown__item'>
        <span class='time'>#{[v[0].to_i, 0].max}</span>
        <span class='label'>#{v[1]}</span>
      </div>"
    end.join(' ')
  end
end
