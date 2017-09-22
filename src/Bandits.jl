module Bandits
import Distributions
import Base: >=, <=, +, /

export
    Bandit, StaticBandit, staticbandit, pull, regret,
    Arm, RandomArm,
    Policy, GreedyPolicy, EpsilonGreedyPolicy, choose,
    Agent, BasicAgent, choose, observe,
    Action, generate_arbitrary_action,
    BanditStats, simulate, aggregate_simulate

include("utils.jl")
include("actions.jl")
include("bandit.jl")
include("policy.jl")
include("agent.jl")
include("simulate.jl")

end
