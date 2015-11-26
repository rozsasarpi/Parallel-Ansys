%Collect batch results from a given batch(parallel group) run
%
%SYNOPSYS
% COLLECT_BATCH_RESULTS(Model, batch_size)
%
%See also
% parallel_ansys

function collect_batch_results(Model, batch_size, batch_index)

% populate the workspace with first level structure fields
cellfun(@(field) assignin('caller', field, Model.(field)), fieldnames(Model))

if batch_index == 1
    result_num = 1:batch_size(batch_index);
else
    result_num = (1+sum(batch_size(1:(batch_index-1)))):sum(batch_size(1:(batch_index)));
end

n_parrun = batch_size(batch_index);
% loop over the parrel jobs in a particular batch
for ii = 1:n_parrun
    job_dir = fullfile(working_dir, ['job',num2str(ii),'_tmp']);
    
    % copy requested results to Ansys working directory
    % loop over the input variables
    for jj = 1:length(input_var_name)
        job_result = fullfile(job_dir, result_file{jj});
        copyfile(job_result, fullfile(working_dir, [result_name{jj},...
            '_',num2str(result_num(ii)),'.txt']))
    end
    
    % delete completed jobs
    if ~(keep_last_batch == 1 && batch_index == length(batch_size))
        if exist(job_dir, 'dir')
            rmdir(job_dir,'s')
        end
    end
    
end

end