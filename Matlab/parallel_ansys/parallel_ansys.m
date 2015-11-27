%Run Ansys in parallel batch mode
%
%SYNOPSYS
% R = PARALLEL_ANSYS(Model)
%
%INPUT
% Model.              
%   .working_dir        full path to Ansys working dir /str/
%   .input_file         name of the Ansys input file with extension /str/
%   .input_var.         
%       .var1           first changing parameter=variable/matrix/          
%                       ['input_',input_var.var1,'.txt'] is created in
%                       input_data folder, it should be called from the
%                       Ansys input file                  
%       ...
%       .varn           all input variable should have the same dimension
%                       /k element vector/
%   .result_file        name of the results file(s) with extension 
%                       created by Ansys
%                       /str or cell of strings (with m elements)/
%   .ansys_exe          path to Ansys batch mode exe, 
%                       /str; e.g.'...\ANSYS
%                       Inc\v[xxx]\ANSYS\bin\winx[yy]\ansys[xxx].exe'/
%
%OPTIONAL INPUT
% Model.
%   .input_var_dir      directory of inputs in Ansys working directory 
%                       /str; default = .working_dir/
%   .output_file        name of the Ansys input file /str; 
%                       default = input_file (with *.out extension)/  
%   .licence            cell with string elements indicating licences,
%                       repeat a particular licence if that can be used for 
%                       multiple instances, /cell with string elements; 
%                       default = {'ansys'; 'ansys'; 'struct'; 'struct'; 'prf'; 'prf'; 'ane3fl'; 'ane3fl'}/
%   .keep_last_batch    /logical; default = 0/
%
%
%
%OUTPUT
% R(k).                 /array of structures/
%   .result_file{1}
%   ...
%   .result_file{m} 
%
%
%DESCRIPTION
% Run Ansys in parallel batch mode: the code divides the task into batches
% based on the available number of licences. One licence allows two
% parallel runs.
%
% Note:
%  * place the ansys mac or inp file, .input_file, in the .working_dir
%  * see the example for the recommended structuring of files, folders, and
%    naming convention
%  * ['input_var_', Model.input_var] automatic naming is created by the
%    Matlab function, this should be in line with the Ansys APDL code
%  * parfor with default settings is used for parallel computing, thus it
%    can happen that lower number of jobs are running parallel than licence
%    available, configure parfor in run_ansys.m
%
%
% Working of the code:
%   1. form blocks with 'n' number of jobs (to be run parallel), start with
%      the first block
%   2. create temporary folders in the main Ansys working folder for parallel jobs: /job1_tmp,
%      /job2_tmp, ... ,/job'n'_tmp
%   3. run 'n' jobs/analyses parallel and save the requested results to the
%      corresponding folders
%   4. collect and copy the requested results to the main Ansys working folder
%   5. Delete the temporary job folders
%   6. Go to step 1. and move to the next block if any
%
%GitHub
%https://github.com/rozsasarpi/ansys_misc/tree/master/Parallel%20ansys
%
%See also
% run_ansys

% TODO:
% * Optimize resource allocation, we might ask Ansys to care for this:
%   http://www.padtinc.com/blog/the-focus/serial-and-parallel-ansys-mechanical-apdl-simulations
% * the Model organization is a little bit messy and rigid -> improve
% * assignin vs global variables?
% * option to keep all analysis files
% * initialize R structure in get_results.m
% * input_var_dir should be the working_dir by default, results should be
%   collected to a results folder + copy all files from working_dir to tmp
%   job dirs except of the results folder (possible remainer from prev
%   analysis)

%..........................................................................
% TEST INPUT
% Model.working_dir     = 'd:\Working folder\ANSYS working folder\frame_test';
% Model.input_file      = 'frame_test.mac';
% Model.input_var_dir   = 'input_data';
% Model.input_var.Fx    = [1e4,2e4];
% Model.input_var.Fy    = [1e4,1e4];
% Model.ansys_exe       = 'C:\Program Files\ANSYS Inc\v162\ANSYS\bin\winx64\ansys162.exe';
% Model.result_file     = {'mid_displ_x.txt'; 'mid_displ_y.txt'};
% tailor the input to your settings
%..........................................................................

function R = parallel_ansys(Model)

%==========================================================================
% PREPROCESSING
%==========================================================================
% set default values for unspecified variables and check the inputs
Model = update_Model(Model);

% assign batch sizes based on the available licences and requested runs
[batch_size, n_batch] = prepare_batches(Model);

% loop over the batches - parallel run packages
for ii = 1:n_batch
    %======================================================================
    % ANALYSIS
    %======================================================================
    run_ansys_cmd = prepare_jobs(Model, batch_size, ii);
    % actual parallel runs
    run_ansys(run_ansys_cmd)
    
    %======================================================================
    % POSTPROCESSING
    %======================================================================
    % move requested result files to the Ansys working folder
    collect_batch_results(Model, batch_size, ii)
end

% get all results to a Matlab variable R /array of structures/
R = get_results(Model, batch_size);

end