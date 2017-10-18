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
  end
end
