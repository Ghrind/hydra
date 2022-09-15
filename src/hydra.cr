require "./hydra/*"

module Hydra
    Log = ::Log.for(self)
    EventLog = Hydra::Log.for("event")
end
