class AddFaqtypeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :faqs, :faqtype, :text
  end
end
