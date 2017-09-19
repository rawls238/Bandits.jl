module Bandits

export
    Bandit, StaticBandit, pull
    Policy, EpsilonGreedyPolicy, choose,
    Agent, BasicAgent, choose, observe,
    Action, generate_arbitrary_action

include("utils.jl")
include("actions.jl")
include("bandit.jl")
include("policy.jl")
include("agent.jl")

end
