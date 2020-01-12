using Distributed: @distributed

mutable struct BanditStats
  regret::Float64
  arm_counts::AbstractVector{Float64}
end
+(a::BanditStats, b::BanditStats) = BanditStats(a.regret + b.regret, a.arm_counts + b.arm_counts)
/(a::BanditStats, n::Integer) = BanditStats(a.regret / n, a.arm_counts / n)

function simulate(bandit::Bandit, agent::Agent, periods::Integer)
  total_regret = 0
  while agent.period < periods
    action = choose(agent)
    reward = pull(bandit, action)
    total_regret += regret(bandit, action)
    observe(agent, reward)
  end
  BanditStats(total_regret, agent.action_attempts)
end


function aggregate_simulate(bandit::Bandit, agent::Agent, periods::Integer, n::Integer)
  qs = @distributed (+) for i=1:n
    simulate(bandit, agent, periods)
  end
  return qs / n
end
