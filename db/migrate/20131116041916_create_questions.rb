class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
			t.integer :exam_id
			t.integer :num
			t.integer :score
			t.string :subject
			t.string :question
			t.string :answers
			t.string :answer
			t.string :material, :default=>'md'	#html, game, etc
      t.timestamps
    end
  end
end
