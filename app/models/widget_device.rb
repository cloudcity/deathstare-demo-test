# @author Chuck Fitzpatrick

class WidgetDevice < Deathstare::UpstreamSession
  validates_presence_of :client_device_id, :username, :email
  validates_uniqueness_of :client_device_id, :username, :email, scope: :end_point_id

  def generate
    self.client_device_id = info.client_device_id = SecureRandom.uuid
    self.username = info.username = SecureRandom.hex(20)
    self.email = info.email = Faker::Internet.email
    info.password = SecureRandom.urlsafe_base64
  end

  def session_params
    {session_token: info.session_token}
  end

  session_state(:created) do |client|
    client.http(:post, '/api/client_devices', {client_device_id: info.client_device_id})
  end

  session_state(:registered) do |client|
    client.http(:post, '/api/users', client_device_id: info.client_device_id,
                username: info.username, email: info.email, password: info.password
    ).then {|r| info.user_id = r[:response][:id] }
  end

  session_state(:logged_in) do |client|
    client.http(:post, '/api/login',  client_device_id: info.client_device_id,
                email_username: info.email, password: info.password
    ).then {|r| info.session_token = r[:response][:session_token] }
  end
end