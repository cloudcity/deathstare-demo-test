require 'faker'

module WidgetFake

  class Widget
    attr_reader :device

    def initialize(device)
      @device = device
      @title = Faker::Commerce.product_name
      @description = Faker::Company.catch_phrase
    end

    def to_h
      {
          title: @title,
          description: @description
      }
    end

  end


end

