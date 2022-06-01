class AddColumnToProposal < ActiveRecord::Migration[7.0]
  def change
    add_column :proposals, :description, :text
    remove_column :proposals, :occurences
    add_column :proposals, :date_proposale, :date
  end
end
