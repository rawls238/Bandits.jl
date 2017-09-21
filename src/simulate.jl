type BanditStats
  regret::Float64
  arm_counts::AbstractVector{Float64}
end

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
