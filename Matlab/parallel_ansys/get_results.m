%Collect all results for Matlab
%
%SYNOPSYS
% GET_RESULTS(Model, batch_size)
%
%See also
% parallel_ansys

function R = get_results(Model, batch_size)

% populate the workspace with first level structure fields
cellfun(@(field) assignin('caller', field, Model.(field)), fieldnames(Model))

% the structure should initialized!
% loop over all the runs
for ii = 1:sum(batch_size)
    % loop over the input variables
    for jj = 1:length(result_name)
        R(ii).(result_name{jj}) = dlmread(fullfile(working_dir,...
            ['results/', result_name{jj}, '_',num2str(ii),'.txt']));
    end
    
end

end