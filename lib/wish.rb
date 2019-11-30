class Wish

  def initialize(elements)
    # .strip - удаляет пробелы и так же знаки на подобие:(\t,\n и т.д.)
    # присваеиваем весь текст
    @text = elements.text.strip
    # Парсим и присваиваем дату
    @data = Date.parse(elements.attributes['date'])
  end

  # Проверка должно ли было сбыться желание ил инет
  # если да то вернет true, иначе false
  def done?
    @data < Date.today
  end

  # Вывести в строку
  def to_str
    # .strftime(условие) - форматирует дату в соответствеии с заданными условиями
    # %d.%m.%Y - День.Месяц.Год
    puts "#{@data.strftime("%d.%m.%Y")}: #{@text}"
  end
end
