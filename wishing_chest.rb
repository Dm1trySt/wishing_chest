require 'rexml/document'
require 'date'

puts "В этом сундуке хранятся ваши желания."
puts "Чего бы вы хотели?"

# Ввод действия
wish_text = STDIN.gets.chomp

puts "До какого числа вы хотите осуществить это желание?"\
"(укажите дату в формате ДД.ММ.ГГГГ)"

# Ввод даты
data_input = STDIN.gets.chomp

# Для хранения даты и последующей записи в xml
data = nil

# Если пользователь не ввел дату, ставим сегодняшнюю
if data_input == ''
  data = Date.today
else
  # Если ввел - парсим
  data = Date.parse(data_input)
end

# Путь до папки с программой
current_path = File.dirname(__FILE__ )

# Путь до файла
file_path = current_path + "/data/wishing_chest.xml"

# Если файл с сундуком не найден, его надо создать
unless File.exist?(file_path)
  # File.open ... do|elements| - создает файл при отсутствии и проводит определенные
  # действия с elements.
  # Файл сразу после выполнения действий в блоке файл будет закрыт.
  File.open(file_path, 'w:UTF-8') do |file|

    # Добавим в документ служебную строку с версией и кодировкой и пустой тег
    file.puts "<?xml version='1.0' encoding='UTF-8'?>"

    # Добавим тег 'wishes'
    file.puts '<wishes></wishes>'
  end
end



# Читаем файл
file = File.read(file_path, encoding: "UTF-8")

# Если файл не открылся !
begin
  doc = REXML::Document.new(file)
    # Ошибка при неудачной попытке открыть файл - ParseException
rescue REXML::ParseException => e
  puts "XML файл похоже битый =("
  abort e.message
end

# Запись даты в тег 'wish' в аттрибут 'date'
wish = doc.root.add_element('wish', {'date' => data.strftime('%d.%m.%Y')})

# .text - содержимое тега
wish.add_text(wish_text)

# Запись файла
File.open(file_path, "w:UTF-8") do |file|
  doc.write(file, 2)
end
puts "Записть успешно сохранена"

# Переменная будет хранить желания, которые
# должны были произойти
happened = []

# Переменная будет хранить желания, которые произойдут в будущем
happens = []

doc.elements.each("wishing_chest/wish") do |element|
  output_date = Date.parse(element.attributes["date"])
  text = element.text

  if Date.today > output_date
    happened << output_date + text
  else
    #  happens << output_date + text
  end
end
puts "Эти желания должны уже были сбыться к сегодняшнему дню:"
puts happened.to_s
puts "А этим желаниям ещё предстоит сбыться:"
puts happens