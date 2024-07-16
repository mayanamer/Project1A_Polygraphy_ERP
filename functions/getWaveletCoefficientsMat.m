% get wavelet coefficients vector for all subjects

function wt_coeff_mat = getWaveletCoefficientsMat(var_names, honest_path, guilty_path, channel)
    num_signals = numel(var_names);
    wt_coeff_mat = zeros(num_signals*2*5, 1);
    
   
    % guilty results

    for i = 1:num_signals
        var_name = var_names{:, i};
        load(guilty_path, var_name);
        signal = eval(var_name);
        signal = avg_with_channels(signal, 1.6, 0.002, [channel]);
        signal = signal(:, 0.6*500:0.9*500);
        wt_coeff_mat(5*(i-1)+1:5*i,1) = wvt_coeff(signal).';
    end


    % honest results

    for i = 1:num_signals
        var_name = var_names{:, i};
        load(honest_path, var_name);
        signal = eval(var_name);
        signal = avg_with_channels(signal, 1.6, 0.002, [channel]);
        signal = signal(1, 0.6*500:0.9*500);
        wt_coeff_mat(5*(i-1+num_signals)+1:5*(i+num_signals),1) = wvt_coeff(signal).';
    end

end