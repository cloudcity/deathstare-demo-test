require 'deathstare/suite'
require 'widget_fake'

class WidgetSuite < Deathstare::Suite

  test "1 - create widgets" do |device|
    device.post('/api/widget', WidgetFake::Widget.new(device).to_h)
  end

  test '2 - widgets list' do |device|
    request_times(10) do
      device.get("/api/widget")
    end
  end

  test "3 - create a widget, get list of all widgets, then delete the widget" do |device|
    my_widget_ids = []
    request_times(10) do
      device.post('/api/widget', WidgetFake::Widget.new(device).to_h).
          then { |r|
        my_widget_ids << r[:id]; r
      }
    end.then do
      device.get("/api/widget").then do
        request_each(my_widget_ids) do |widget_id|
          device.delete('/api/widget', id: widget_id)
        end
      end
    end
  end

end
