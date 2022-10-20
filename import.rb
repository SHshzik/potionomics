# require 'sqlite3'
# require 'csv'
#
# db = SQLite3::Database.new 'potionomics.db'
#
# table = CSV.parse(File.read('1.csv'), headers: true)
#
# table.each do |row|
#   db.execute(
#     "insert into ingredients values ( ?, ?, ?, ?, ?, ?, ?, ? )",
#     [
#       row['Ingredients'],
#       row['A'].to_i,
#       row['B'].to_i,
#       row['C'].to_i,
#       row['D'].to_i,
#       row['E'].to_i,
#       row['Price (Quinn)'].to_i,
#       0
#     ]
#   )
# end
