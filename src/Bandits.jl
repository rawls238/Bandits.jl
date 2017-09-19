module Bandits

export
    Bandit,
    Policy,
    Agent

include("utils.jl")
include("actions.jl")
include("bandit.jl")
include("policy.jl")
include("agent.jl")

end
