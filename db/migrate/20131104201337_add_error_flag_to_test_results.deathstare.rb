# This migration comes from deathstare (originally 20131104191907)
class AddErrorFlagToTestResults < ActiveRecord::Migration
  def change
    add_column :deathstare_test_results, :error, :boolean, default:false
    add_index :deathstare_test_results, [:test_session_id, :error]
  end
end
