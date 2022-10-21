require 'sqlite3'
require 'highline'

db = SQLite3::Database.new 'potionomics.db'
cli = HighLine.new

ingredients = db.execute('select * from ingredients order by name')

selected_ingredient = nil
cli.choose do |menu|
  menu.prompt = "Выбери ингредиент: "
  ingredients.each do |ingredient|
    menu.choice(ingredient[0]) { selected_ingredient = ingredient }
  end
end

count = cli.ask("Количество: ", Integer)

item = db.execute("select * from inventory where ingredient == '#{selected_ingredient[0]}'").first

unless item.nil?
	p db.execute("update inventory set count = #{item[1] + count} where ingredient == '#{item[0]}'")
else
	p db.execute("insert into inventory values('#{selected_ingredient[0]}', #{count})")
end	
