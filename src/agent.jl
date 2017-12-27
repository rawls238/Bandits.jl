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
function BasicAgent(policy::Policy, bandit::Bandit, initial_mean::Integer, belief::AbstractVector{Float64}) 
  BasicAgent(belief, policy, bandit, 0, zeros(bandit.num_arms), zeros(bandit.num_arms), -1)
end
BasicAgent(policy::Policy, bandit::Bandit, belief::AbstractVector{Float64}) = BasicAgent(policy, bandit, 0, belief)

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

type NormalAgent <: Agent
  prior_mean::AbstractVector{Float64}
  prior_variance::AbstractVector{Float64}
  empirical_mean::AbstractVector{Float64}
  policy::Policy
  bandit::Bandit
  period::Integer
  action_attempts::AbstractVector{Float64}
  total_reward::AbstractVector{Float64}
  last_action::Integer
end
function NormalAgent(prior_mean::AbstractVector{Float64}, prior_variance::AbstractVector{Float64}, policy::Policy, bandit::Bandit)
  NormalAgent(prior_mean, prior_variance, zeros(K), policy, bandit, -1, zeros(K), zeros(K), -1)
end
NormalAgent(policy::Policy, bandit::Bandit) = NormalAgent(zeros(bandit.num_arms), ones(bandit.num_arms), policy, bandit)

get_variances(a::NormalAgent) = prior_variance ./ (1 + action_attempts)

function observe(agent::NormalAgent, reward::Float64)
  agent.period += 1
  agent.action_attempts[agent.last_action] += 1
  agent.total_reward[agent.last_action] += reward
  agent.empirical_mean = agent.total_reward ./ agent.action_attempts
end

function randomSample(agent::NormalAgent)
  variances = get_variances(agent)
  return [rand(normal(empirical_mean[i], variances[i]) for i in 1:length(empirical_mean))]
end
