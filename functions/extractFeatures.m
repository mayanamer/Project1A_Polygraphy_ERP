% this function will apply featur extraction functions onto the signal it
% got, and place them in a vector
function [feature_vector] = extractFeatures(signal)
    constScript; % holds all the constants
    % Min_Max_abs
    feature_abs_min = min(abs(signal));
    feature_abs_max = max(abs(signal));   

    % Min_Max_Non_abs
    feature_min = min(signal);
    feature_max = max(signal);

    % Entropy
    feature_entropy = jfeeg('sh', signal);

    % Band Power
    opts.fs = fs;
    feature_dalta_bp = jfeeg('bpd' , signal, opts);
    feature_alpha_bp = jfeeg('bpa' , signal, opts);
    feature_beta_bp = jfeeg('bpb' , signal, opts);
    feature_gamma_bp = jfeeg('bpg' , signal, opts);

    % Max Slope
    feature_peak2peak = peak2peak(signal);

    feature_vector = [  feature_abs_min, ...
                        feature_abs_max, ...
                        feature_min, ...
                        feature_max, ...
                        feature_entropy, ...
                        feature_dalta_bp, ...
                        feature_alpha_bp, ...
                        feature_beta_bp, ...
                        feature_gamma_bp, ...
                        feature_peak2peak, ...
                        ];

end