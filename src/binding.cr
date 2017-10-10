class Binding
  getter :target
  getter :behavior
  getter :params

  def initialize(target : String, behavior : String, params = "")
    @target = target
    @behavior = behavior
    @params = params
  end
end
