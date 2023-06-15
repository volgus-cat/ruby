#===============================================================
#                Класс работы со станцией
#===============================================================
class Station
  attr_accessor :name, :trainS

  def initialize(name)
      @name = name   # имя станции
      @trainS = []   # массив поездов на этой станции
  end

  # перекрыть стандартный метод для puts, print
  def to_s 
      @name
  end

  # добавить поезд на станцию
  def add_train(train) 
      @trainS << train
  end
  
  # отправить поезд со станци
  def send_train(train)
      @trainS.delete(train)
  end
  
  # список поездов по типу
  def trains_type(type)
      @trainS.select { |train| train.type == type }
  end

  # список поездов на станции
  def full_info(current_train_number)
    puts "На станции <#{@name}> находятся поезда: "
    if @trainS.size == 0
        puts "   -"
    else     
         @trainS.each do |t|
            if current_train_number == t.number 
               puts "   #{t.number }             <=========================( поезд для манипуляций )"
            else           
               puts "   #{t.number }"
            end
         end
    end
  end
end
