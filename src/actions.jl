type Action
  name::AbstractString
  value::Float64
end

generate_arbitrary_actions(num_actions::Integer) =[Action(string(i), i) for i in 1:num_actions]
