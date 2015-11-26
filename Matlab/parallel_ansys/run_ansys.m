%Run Ansys
%
%SYNOPSYS
% RUN_ANSYS(run_ansys_cmd)
%
%See also
% parallel_ansys

function run_ansys(run_ansys_cmd)

n_parrun = length(run_ansys_cmd);

[~, d] = version;
release_year = str2double(d(end-4:end));

parfor ii = 1:n_parrun
    if release_year >= 2014 %since R2014b to handle the stack overflow problem
        system(['SET KMP_STACKSIZE=2048k & ', run_ansys_cmd{ii}]);
    else
        system(run_ansys_cmd{ii})
    end
end

end