using Plots
gr()
#=
Write some simple functions to perform transformation of signals of length
256 or 512. With these functions perform some experiments with zero padding.
=#

function base_transformation(in_signal, exp)
    stored_diff = []
    for ii in 1:exp
        signal_length = size(in_signal, 2)
        mean_array = Array{Float64}(undef, signal_length)
        diff_array = Array{Float64}(undef, signal_length)
        for i in 1:signal_length
            in1, in2 = in_signal[:, i]
            ave = (in1 + in2) / 2
            diff = ave - in1
            mean_array[i] = ave
            diff_array[i] = diff
        end
        stored_diff = [stored_diff; diff_array]
        output = mean_array
        if length(output) > 1
            in_signal = pair(output)
        elseif length(output) == 1
            in_signal = output
        end
    end
    return in_signal, stored_diff
end

function pair(signal)
    new = reshape(signal, (2, div(length(signal), 2)))
    return new
end

function calculate_padding(input_signal)
    # input signal must have length 2 ^ n
    x = length(input_signal)
    l = ceil(log(2, x))
    full = 2 ^ l
    add = convert(Int64, full - x)
    pad = zeros(1, add)
    padded = [input_signal pad]
    return padded, l
end

signal = rand(1, 2048)
signal, exp = calculate_padding(signal)
new = pair(signal)
output, diff = base_transformation(new, exp)
decomposed = [output; diff]

plot(diff)

signal = rand(1, 2049)
signal, exp = calculate_padding(signal)
new = pair(signal)
output, diff = base_transformation(new, exp)
decomposed = [output; diff]

plot(diff)
