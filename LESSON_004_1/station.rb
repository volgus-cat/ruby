#===============================================================
#                Класс работы со станцией
#===============================================================
class Station
  attr_accessor :name, :trains

  def initialize(name)
      @name = name   # имя станции
      @trains = []   # массив поездов на этой станции
  end

  # перекрыть стандартный метод для puts, print
  def to_s 
      @name
  end

  # добавить поезд на станцию
  def add_train(train) 
      @trains << train
  end
  
  # отправить поезд со станци
  def send_train(train)
      @trains.delete(train)
  end
  
  # список поездов по типу
  def trains_type(type)
      @trains.select { |train| train.type == type }
  end

  # список поездов на станции
  def full_info(current_train_number)
    puts "На станции <#{@name}> находятся поезда: "
    if @trains.size == 0
        puts "   -"
    else     
         @trains.each do |t|
            if current_train_number == t.number 
               puts "   #{t.number }  #{t.route.stations.first} - #{t.route.stations.last}         <=========================( поезд для манипуляций )"
            else           
               puts "   #{t.number }  #{t.route.stations.first} - #{t.route.stations.last}"
            end
         end
    end
  end
end
