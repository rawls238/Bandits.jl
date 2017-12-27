observe(a::Agent, reward::Float64) = 0
function choose(a::Agent)
  action_idx = choose(a.policy, a)
  a.last_action = action_idx
  return action_idx
end

type BasicAgent <: Agent
  empirical_mean::AbstractVector{Float64}
  policy::Policy
  bandit::Bandit
  period::Integer
  action_attempts::AbstractVector{Float64}
  total_reward::AbstractVector{Float64}
  last_action::Integer
end
function BasicAgent(policy::Policy, bandit::Bandit, initial_mean::Integer) 
  BasicAgent(ones(bandit.num_arms) * initial_mean, policy, bandit, 0, zeros(bandit.num_arms), zeros(bandit.num_arms), -1)
end
BasicAgent(policy::Policy, bandit::Bandit) = BasicAgent(policy, bandit, 0)

function observe(agent::BasicAgent, reward::Float64)
  agent.period += 1
  agent.action_attempts[agent.last_action] += 1
  agent.total_reward[agent.last_action] += reward
  agent.empirical_mean = agent.total_reward ./ agent.action_attempts
end

type BetaBernoulliAgent <: Agent
  α::AbstractVector{Float64}
  β::AbstractVector{Float64}
  empirical_mean::AbstractVector{Float64}
  policy::Policy
  bandit::Bandit
  period::Integer
  action_attempts::AbstractVector{Float64}
  total_reward::AbstractVector{Float64}
  last_action::Integer
end

function observe(agent::BetaBernoulliAgent, reward::Float64)
  agent.period += 1
  agent.action_attempts[agent.last_action] += 1
  agent.total_reward[agent.last_action] += reward
  if reward == 1
    agent.α[agent.last_action] += 1
  else
    agent.β[agent.last_action] += 1
  end
  α = agent.α[agent.last_action]
  β = agent.β[agent.last_action]
  return (α + β) / β
end

randomSample(agent::BetaBernoulliAgent) = [rand(beta(agent.α[i], agent.β[i])) for i in 1:length(agent.total_reward)]
