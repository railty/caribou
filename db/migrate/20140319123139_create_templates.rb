class CreateTemplates < ActiveRecord::Migration
  def change
    create_table :templates do |t|
			t.integer :score
			t.string :grade
			t.string :subject
			t.string :question
			t.string :answers

      t.timestamps
    end
  end
end
