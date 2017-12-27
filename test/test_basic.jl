using Bandits
using Distributions
using Base.Test


sb = staticbandit([Normal(0,1), Normal(100, 1)])
@test sb.optimal_expected_return == 100
@test regret(sb, 2) == 0

sb = staticbandit([Normal(0,1), Normal(100, 1)])
greedy_policy = GreedyPolicy()
epsilon_greedy_policy = EpsilonGreedyPolicy(0.1)

agent = BasicAgent(greedy_policy, sb, 0, [0.0, 1.0])
stats = simulate(sb, agent, 100)
@test stats.regret ≈ 0 atol=0.01
@test stats.arm_counts[2] ≈ 100 atol=1.10

sb = staticbandit([Normal(0, 1), Normal(100, 1)])
agent_epsilon = BasicAgent(epsilon_greedy_policy, sb, 0, [0.0, 1.0])
stats = simulate(sb, agent_epsilon, 100)
@test stats.regret > 0
@test stats.arm_counts[2] < 100

sb = staticbandit([Normal(0, 1), Normal(100, 1)])
agent_bad_prior = BasicAgent(greedy_policy, sb, 0, [1.0, 0.0])
stats = simulate(sb, agent_bad_prior, 100)
@test stats.regret > 0
@test stats.arm_counts[2] < 100
