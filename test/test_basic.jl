using Bandits
using Distributions
using Test


T = 100
sb = staticbandit([Normal(0,1), Normal(100, 1)])
@test sb.optimal_expected_return == 100
@test regret(sb, 2) == 0

sb = staticbandit([Normal(0,1), Normal(100, 1)])
greedy_policy = GreedyPolicy()
epsilon_greedy_policy = EpsilonGreedyPolicy(0.1)
thompson_sampling = ThompsonSampling()
ucb1 = UCB1()
explore_then_exploit = ExploreThenExploit(T / 4)

agent = BasicAgent(greedy_policy, sb, 0, [0.0, 1.0])
stats = simulate(sb, agent, T)
@test stats.regret ≈ 0 atol=0.01
@test stats.arm_counts[2] ≈ T atol=1.10

sb = staticbandit([Normal(0, 1), Normal(100, 1)])
agent_epsilon = BasicAgent(epsilon_greedy_policy, sb, 0, [0.0, 1.0])
stats = simulate(sb, agent_epsilon, T)
@test stats.regret > 0
@test stats.arm_counts[2] < T

sb = staticbandit([Normal(0, 1), Normal(100, 1)])
agent_bad_prior = BasicAgent(greedy_policy, sb, 0, [1.0, 0.0])
stats = simulate(sb, agent_bad_prior, T)
@test stats.regret > 0
@test stats.arm_counts[2] < T

sb = staticbandit([Normal(0, 100), Normal(0.01, 100)])
normal_agent = NormalAgent(thompson_sampling, sb)
stats = simulate(sb, normal_agent, T)
@test stats.regret > 0

sb = staticbandit([Bernoulli(0.5), Bernoulli(0.6)])
beta_agent = BetaBernoulliAgent([0.6, 0.5], ucb1, sb)
stats = simulate(sb, beta_agent, T)
@test stats.regret > 0
@test stats.arm_counts[1] < T

sb = staticbandit([Bernoulli(0.5), Bernoulli(0.6)])
beta_agent = BetaBernoulliAgent([0.6, 0.5], thompson_sampling, sb)
stats = simulate(sb, beta_agent, T)
@test stats.regret > 0
@test stats.arm_counts[1] < T

sb = staticbandit([Bernoulli(0.5), Bernoulli(0.6)])
beta_agent = BetaBernoulliAgent([0.6, 0.5], explore_then_exploit, sb)
stats = simulate(sb, beta_agent, T)
@test stats.regret > 0
@test stats.arm_counts[1] < T
