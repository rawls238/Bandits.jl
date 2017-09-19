abstract Agent
choose(a::Agent) = 0
observe(a::Agent, reward::Float64) = 0

type BasicAgent <: Agent
  value_beliefs::AbstractArray{Float64}
  policy::Policy
  bandit::Bandit
  period::Integer
  action_attempts::AbstractArray{Float64}
  total_reward::AbstractArray{Float64}
  last_action::Integer
end
BasicAgent(policy::Policy, bandit::Bandit, initial_mean::Integer) = BasicAgent(ones(bandit.num_arms) * initial_mean, policy, bandit, 0, zeros(bandit.num_arms), zeros(bandit.num_arms), -1)
BasicAgent(policy::Policy, bandit::Bandit) = BasicAgent(policy, bandit, 0)

function choose(b::BasicAgent)
  action_idx = choose(b.policy, b)
  b.last_action = action_idx
  return action_idx
end

function observe(agent::BasicAgent, reward::Float64)
  agent.period += 1
  agent.action_attempts[agent.last_action] += 1
  agent.total_reward[agent.last_action] += reward
  agent.value_beliefs = agent.total_reward / agent.action_attempts
end
