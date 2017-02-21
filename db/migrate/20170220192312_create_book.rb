class CreateBook < ActiveRecord::Migration[5.0]
	def change
		create_table :books do |t|
			t.belongs_to 	:author, index: true
			t.text 			:name
			t.datetime 		:published_at
			t.timestamps 
		end
	end
end
