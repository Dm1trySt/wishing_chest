require 'rexml/document'
require 'date'

require_relative 'lib/wish'

# Путь до файла
file_path = File.dirname(__FILE__ ) + "/data/wishing_chest.xml"

# Если файл не найден выведет ошибку
abort "Файл #{file_path} не найден!" unless File.exist?(file_path)

# Считываем данные на основе XML структур и воспользовавшись тем, что
# метод .open возвращает значение, присвоим все содержимое переменной doc
doc = File.open(file_path, "r:UTF-8") do |file|
  REXML::Document.new(file)
end

# Хранит в себе все желания
wishes = []

# Каждый эллемент отправляем в  конструктор класса Wish
# после заносим в массив
doc.elements.each('wishing_chest/wish') do |elements|
  wishes << Wish.new(elements)
end

puts "Эти желания должны были сбыться к сегодняшнему дню:"

# Если при вызове метода done? вернулось true
# будет вызван метод to_str и выведет этот элемент на экран
wishes.each {|element|  element.to_str if element.done?}

puts "А этим желаниям ещё предстоит сбыться"

# Если при вызове метода done? вернулось false
# будет вызван метод to_str и выведет этот элемент на экран
wishes.each {|element|  element.to_str  unless element.done? }



