module Bandits
import Distributions
import Base: >=, <=

export
    Bandit, StaticBandit, pull, regret,
    Arm, RandomArm,
    Policy, EpsilonGreedyPolicy, choose,
    Agent, BasicAgent, choose, observe,
    Action, generate_arbitrary_action,
    BanditStats, simulate

include("utils.jl")
include("actions.jl")
include("bandit.jl")
include("policy.jl")
include("agent.jl")
include("simulate.jl")

end
