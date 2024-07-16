function signal = getSignal(data, subject, session, rep, type)
% this function gives you the signal of the specific params above

    for member = 1:length(data.(type))
        if data.(type){member}.sub == subject && ...
            data.(type){member}.sess == session && ...
            data.(type){member}.rep == rep
            
            signal = data.(type){member}.tab;
        end
    end

end

