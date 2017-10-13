module Hydra
  class Application
    def initialize(view : Hydra::View, event_hub : Hydra::EventHub)
      @view = view
      @event_hub = event_hub
    end
    def start
      @view.render
      loop do
        char = @view.getch
        sleep 0.01
        next unless char >= 0
        @event_hub.broadcast(Hydra::EventHub.char_to_event(char))
        @view.render
      end
      Crt.done
    end

    def message_received(payload : JSON::Any)
      payload.each do |instruction|
        if instruction["element"]?
          case instruction["element"]
          when "log_box"
            @view.add_element(Hydra::LogBox.new(instruction["width"].as_i, instruction["height"].as_i))
          end
        elsif instruction["bind"]?
          @event_hub.bind(instruction["bind"].as_s, instruction["target"].as_s, instruction["behavior"].as_s)
        elsif instruction["do"]?
          @event_hub.trigger(instruction["target"].as_s, instruction["do"].as_s, instruction["params"].as_s)
        end
      end
      @view.render
    end
  end
end
