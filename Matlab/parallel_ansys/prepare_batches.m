%Prepare batches for parallel run
%
%SYNOPSYS
% [batch_size, n_batch] = PREPARE_BATCHES(Model)
%
%See also
% parallel_ansys

function [batch_size, n_batch] = prepare_batches(Model)

% populate the workspace with first level structure fields
cellfun(@(field) assignin('caller', field, Model.(field)), fieldnames(Model))

input_var_name = fieldnames(input_var);
% n_input_var = length(input_var_name);

% requested number of runs
n_run           = length(input_var.(input_var_name{1}));

% available licences
% one licence allows two parallel instances
n_lic           = length(licence);

% number of batches required to complete the requested runs
n_batch         = ceil(n_run/n_lic);

% size of each batches
n_parrun        = min(n_run, n_lic);
batch_size      = repmat(n_parrun, n_batch,1);
if rem(n_run,n_lic) > 0
    batch_size(end) = rem(n_run,n_lic);
end

end