class CreateFaqs < ActiveRecord::Migration[6.1]
  def change
    create_table :faqs do |t|
      t.string :title
      t.text :content
      t.timestamps
    end
  end
end
