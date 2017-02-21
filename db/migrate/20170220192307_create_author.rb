class CreateAuthor < ActiveRecord::Migration[5.0]
	def change
		create_table :authors do |t|
			t.text	:name
			t.timestamps
		end
		Author.create :name => 'Василий Алибабаевич'
		Author.create :name => 'Игорь'
		Author.create :name => 'Сергей'
		Author.create :name => 'Оксана'
		Author.create :name => 'Андрей'
		Author.create :name => 'Екатерина'
	end
end
