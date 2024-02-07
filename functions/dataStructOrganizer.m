% dataStructOrganizer
% orgenizes the data in cell arrays of subjects
% each subject holds 
% 
% 
% a matrix of 4 cannels, and an average of the channels
constScript; % holds all the constants
%%
%curr_path = lying_path_list{1};

cell_arr_lying_p = createStructInner(lying_path_list{1});
cell_arr_lying_t = createStructInner(lying_path_list{2});
cell_arr_lying_i = createStructInner(lying_path_list{3});
cell_arr_honest_p = createStructInner(honest_path_list{1});
cell_arr_honest_t = createStructInner(honest_path_list{2});
cell_arr_honest_i = createStructInner(honest_path_list{3});


%% 

final_data = struct('lying_probe', {cell_arr_lying_p},'lying_target', {cell_arr_lying_t}, ...
    'lying_irrelevant', {cell_arr_lying_i},'honest_probe', {cell_arr_honest_p}, ...
    'honest_target', {cell_arr_honest_t},'honest_irrelevant', {cell_arr_honest_i});
save('final_data.mat', 'final_data', '-v7.3');

%% add the avg of all the electrodes (without EOG and VEOG)

final_data = calcAvg(final_data);
save('final_data.mat', 'final_data', '-v7.3');

%%
function [cell_arr_inner] = createStructInner(curr_path)
% creates structs of all subjects, sessions,and itarations
% and place them all in a cell array
    constScript; % holds all the constants
    cell_arr_inner = {};
    [~,filename,~] = fileparts(curr_path);
    data = load(curr_path);
    for subjectNumber = 1:SUBJECT_NUMBER

        for sessionNumber = 1:SESSION_NUMBER
            try
                for repNumber = 1:size(data.("subject"+subjectNumber+"_session"+sessionNumber),2)
                    session_tab = createSessionTable(data.("subject"+subjectNumber+"_session"+sessionNumber), repNumber).';
                    struct_inner = struct('sub', subjectNumber, 'sess', sessionNumber, 'rep', repNumber, 'tag', filename, 'tab', session_tab);
                    cell_arr_inner{end+1} = struct_inner;
                end
            catch
            
                continue;
                
            end
        end    
    
    end
end


%%

function [subject_table] = createSessionTable(session, repNumber)
    elects = [electrodes.enum.Fp1.index;
        electrodes.enum.Fp2.index;
        electrodes.enum.P3.index;
        electrodes.enum.P4.index];
    constScript; % holds all the constants
    ground = electrodes.enum.Fz.index;
    %                               800 x 5
    subject_table = zeros( [size(session,1) 5] );
    % sum_of_signals = zeros([size(session,1) 1]);
    counter =1;
    for i = 1:CHANNEL_NUMBER
        % if (ismember(i, elects))
            %% run this if you want to subtract the ground
            % if (i == electrodes.enum.Fp1.index ||  i == electrodes.enum.P4.index)
            %     subject_table(:,counter) = session(:,repNumber,ground) - session(:,repNumber,i);
            % else
            %     subject_table(:,counter) = session(:,repNumber,i) - session(:,repNumber,ground);
            % end
        %% run this if you dont want to subtract anything yet
        subject_table(:,counter) = session(:,repNumber,i);
        %%
        counter = counter + 1;
        % end
    end 
end


%%

function [final_data] = calcAvg(final_data)
    fields = fieldnames(final_data);
    for i = 1:numel(fields)
        field = fields{i};
        for j =1:size(final_data.(field),2)
            final_data.(field){1,j}.tab(15,:) = mean(final_data.(field){1,j}.tab(1:12,:));
        end
    end
end



