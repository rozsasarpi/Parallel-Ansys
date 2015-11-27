%Prepare jobs for parallel run
%
%SYNOPSYS
% run_ansys_cmd = PREPARE_JOBS(Model)
%
%See also
% parallel_ansys

function run_ansys_cmd = prepare_jobs(Model, batch_size, batch_index)

% populate the workspace with first level structure fields
cellfun(@(field) assignin('caller', field, Model.(field)), fieldnames(Model))

% run_num contains the numbers of requested runs (global) in the analysed batch
if batch_index == 1
    run_num = 1:batch_size(batch_index);
else
    run_num = (1+sum(batch_size(1:(batch_index-1)))):sum(batch_size(1:(batch_index)));
end

n_parrun = batch_size(batch_index);
run_ansys_cmd   = cell(n_parrun,1);
% loop over the parrel jobs in a particular batch
for ii = 1:n_parrun
    job_dir = fullfile(working_dir, ['job',num2str(ii),'_tmp']);
    
    % delete previous jobs if any
    if exist(job_dir, 'dir')
        rmdir(job_dir,'s')
    end
    % initialize new jobs
    mkdir(job_dir)
    if ~isempty(input_var_dir)
        mkdir(fullfile(job_dir, input_var_dir))
    end
    
    % copy all *.inp and *.mac files to the temporary job folder
    if ~isempty(dir([working_dir, '\*.inp']))
        copyfile([working_dir, '\*.inp'], job_dir)
    end
    if ~isempty(dir([working_dir, '\*.mac']))
        copyfile([working_dir, '\*.mac'], job_dir)
    end
    % copy the files from the input_var_dir to the temporary folder
    dir_data = dir(fullfile(working_dir, input_var_dir));
    dir_index = [dir_data.isdir];
    file_list = {dir_data(~dir_index).name}';
    cellfun(@(x) copyfile(fullfile(working_dir, input_var_dir, x), fullfile(job_dir, input_var_dir)), file_list)
    
    % write input
    % loop over the input variables
    for jj = 1:length(input_var_name)
        var = input_var_name{jj};        
        dlmwrite(fullfile(job_dir, input_var_dir, ['input_var_',var,'.txt']), input_var.(var)(run_num(ii)))
    end
    
    % run commands
    run_ansys_cmd{ii} = ['"',ansys_exe,'" -p ',licence{ii},' -b -dir "',job_dir,'" -i "',...
        fullfile(job_dir, input_file),'" -o "',fullfile(job_dir, output_file),'"'];
end

end