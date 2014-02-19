# This migration comes from deathstar (originally 20131030153107)
class AddCancelledAtToTestSession < ActiveRecord::Migration
  def change
    add_column :deathstar_test_sessions, :cancelled_at, :timestamp
  end
end
