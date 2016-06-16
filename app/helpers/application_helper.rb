# Funciones para todos las vistas
module ApplicationHelper
  # Verifica si un día es hábil
  def habil?(date=Time.now)
    habil = false
    if ((1..5)===date.wday)
      habil = true
    end
    return habil
  end

  # Regresa el nombre del dia de la semana
  def day_of_the_week(day)
      @dias = {1 => "LUNES", 2 => "MARTES", 3 => "MIERCOLES", 4 => "JUEVES",  5 => "VIERNES", 6 => "SÁBADO", 7 => "DOMINGO"}
      return @dias[day]
  end

  # De acuerdo al número de día, regresa un color hexadecimal
  def colors_to_days
   return @backgrounds_colors = {0 => "#82FA58",
                                                   1 => "#feaeff", 2 => "#A9A9F5", 3 => "#31B404", 4=> "#F2F5A9", 5 => "#EDD46F", 6 => "#20d6d0"}
  end

  def html_title(*args)
    if args.empty?
      title = []
      title += @html_title if @html_title
      title << Setting.app_title
      title.select {|t| !t.blank? }.join(' - ')
    else
      @html_title ||= []
      @html_title += args
    end
  end

  def custom_format(date=nil)
      return date.strftime("%d de %B de %Y, %H:%M %p ").upcase if date && (date.respond_to?(:strftime))
  end

end
