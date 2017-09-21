abstract type Policy end
abstract type Agent end

choose(p::Policy, a::Agent) = 0

immutable GreedyPolicy <: Policy end
choose(p::GreedyPolicy, a::Agent) = rand(findallmax(a.value_belief))

immutable EpsilonGreedyPolicy <: Policy
    ϵ::Float64
end

function choose(p::EpsilonGreedyPolicy, a::Agent)
    if rand() < p.ϵ
      return rand(1:length(a.value_belief))
    else
      return rand(findallmax(a.value_belief))
    end
end
