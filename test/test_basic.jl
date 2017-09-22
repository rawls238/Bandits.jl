using Bandits
using Base.Test


sb = staticbandit([Normal(0,1), Normal(100, 1)])
greedy_policy = GreedyPolicy()
epsilon_greedy_policy = EpsilonGreedyPolicy(0.05)

agent = BasicAgent(greedy_policy, sb, 0)
stats = simulate(sb, agent, 100)
@test_approx_eqs stats.regret 0 0.01
@test_approx_eqs stats.action_attempts[2] 100 1.1 
