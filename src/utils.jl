# Source: https://stackoverflow.com/questions/41636928/julia-find-the-indices-of-all-maxima
# returns max indices 
function find_all_max_indices(arr)
    max_positions = Vector{Int}()
    min_val = typemin(eltype(arr))
    for i in eachindex(arr)
        if arr[i] > min_val
            min_val = arr[i]
            empty!(max_positions)
            push!(max_positions, i)
        elseif arr[i] == min_val
            push!(max_positions, i)
        end
    end
    max_positions
end
