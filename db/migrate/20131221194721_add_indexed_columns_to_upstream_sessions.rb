class AddIndexedColumnsToUpstreamSessions < ActiveRecord::Migration
  def change
    add_column :deathstare_upstream_sessions, :username, :string
    add_column :deathstare_upstream_sessions, :email, :string
    add_column :deathstare_upstream_sessions, :client_device_id, :string
    add_index :deathstare_upstream_sessions, [:username, :end_point_id], unique:true
    add_index :deathstare_upstream_sessions, [:email, :end_point_id], unique:true
    add_index :deathstare_upstream_sessions, [:client_device_id, :end_point_id],
      unique:true, name:'upstream_sessions_client_device'
  end
end
