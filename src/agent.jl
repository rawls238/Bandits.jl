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
  agent.empirical_mean[agent.last_action] = agent.total_reward[agent.last_action] / agent.action_attempts[agent.last_action]
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
function BetaBernoulliAgent(α::AbstractVector{Float64}, β::AbstractVector{Float64}, policy::Policy, bandit::Bandit)
  BetaBernoulliAgent(α, β, α ./ (α + β), policy, bandit, 0, zeros(bandit.num_arms), zeros(bandit.num_arms), -1)
end
BetaBernoulliAgent(means::AbstractVector{Float64}, policy::Policy, bandit::Bandit) = BetaBernoulliAgent(means, 1 - means, policy, bandit)
BetaBernoulliAgent(policy::Policy, bandit::Bandit) = BetaBernoulliAgent(ones(bandit.num_arms), ones(bandit.num_arms), policy, bandit)


observe(agent::BetaBernoulliAgent, reward::Integer) = observe(agent, convert(AbstractFloat, reward))
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
  agent.empirical_mean[agent.last_action] = α / (α + β)
end

randomSample(agent::BetaBernoulliAgent) = [rand(Beta(agent.α[i], agent.β[i])) for i in 1:length(agent.empirical_mean)]

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
  NormalAgent(prior_mean, prior_variance, zeros(length(prior_mean)), policy, bandit, -1, zeros(length(prior_mean)), zeros(length(prior_mean)), -1)
end
NormalAgent(policy::Policy, bandit::Bandit) = NormalAgent(zeros(bandit.num_arms), ones(bandit.num_arms), policy, bandit)

get_variances(a::NormalAgent) = a.prior_variance ./ (1 + a.action_attempts)

function observe(agent::NormalAgent, reward::Float64)
  agent.period += 1
  agent.action_attempts[agent.last_action] += 1
  agent.total_reward[agent.last_action] += reward
  agent.empirical_mean[agent.last_action] = agent.total_reward[agent.last_action] / agent.action_attempts[agent.last_action]
end

function randomSample(agent::NormalAgent)
  variances = get_variances(agent)
  rands = [rand(Normal(agent.empirical_mean[i], variances[i])) for i in 1:length(agent.empirical_mean)]
  return rands
end

