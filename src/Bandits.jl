module Bandits
import Base: >=, <=, +, /

export
    Bandit, StaticBandit, staticbandit, pull, regret,
    Policy, GreedyPolicy, EpsilonGreedyPolicy, ExploreThenExploit, UCB1, ThompsonSampling, choose,
    Agent, BasicAgent, BetaBernoulliAgent, NormalAgent, randomSample, choose, observe,
    Action, BanditStats, simulate, aggregate_simulate

include("utils.jl")
include("actions.jl")
include("bandit.jl")
include("policy.jl")
include("agent.jl")
include("simulate.jl")

end
