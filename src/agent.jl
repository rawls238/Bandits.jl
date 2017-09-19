abstract Agent

type BasicAgent <: Agent
  value_beliefs::AbstractArray{Float64}
  prior::AbstractArray{Float64}
  policy::Policy
  bandit::Bandit
  period::Integer
  action_attempts::AbstractArray{Float64}
end

function BasicAgent(prior::AbstractArray{Float64}, policy::Policy, bandit::Bandit)
  BasicAgent(prior, prior, policy, bandit, 0, zeros(length(prior)))
end

function reset(b::BasicAgent)
  b.action_attempts = zeros(length(b.action_attempts))
  b.period = 0
end

function choose(b::BasicAgent)
  action_idx = choose(b.policy, b)
  b.action_attempts[action_idx] += 1
end

function observe(agent::BasicAgent, reward::Float64)
end

