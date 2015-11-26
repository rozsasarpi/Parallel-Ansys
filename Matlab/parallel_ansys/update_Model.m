%Update the Model structure and check the provided inputs
%
%SYNOPSYS
% upModel = UPDATE_MODEL(Model)
%
%See also
% parallel_ansys

function upModel = update_Model(Model)

% populate the workspace with first level structure fields
cellfun(@(field) assignin('caller', field, Model.(field)), fieldnames(Model))

% available licences
if ~exist('licence', 'var')
    licence = {'ansys'; 'ansys'; 'struct'; 'struct'; 'prf'; 'prf'; 'ane3fl'; 'ane3fl'};
end

if ~exist('working_dir', 'var')
    error('Ansys working directory /Model.working_dir/ (*.mac, *.inp) is not specified!')
end

if ~exist('input_file', 'var')
    error('Ansys input file name /Model.input_file/ (*.mac, *.inp) is not specified!')
end

% is the input_file given with extension?
if input_file(end-3) ~= '.'
    error('Ansys input file name /Model.input_file/ should be given with extension, e.g. *.mac, *.inp)!')
end
input_file_ext = input_file((end-2):end);

if ~exist('input_var', 'var')
    error('Input variables /Model.input_var/ are not specified!')
end

if ~exist('result_file', 'var')
    error('Result file /Model.result_file/ is not specified!')
end

% is the result_file given with extension?
for ii = 1:length(result_file)
    rf = result_file{ii};
    if rf(end-3) ~= '.'
        error('Ansys result file name /Model.result_file/ should be given with extension, e.g. *.txt)!')
    end
end

if ~exist('output_file', 'var')
    output_file = [input_file(1:(end-4)),'.out'];
end

if ~exist('ansys_exe', 'var')
    error('Ansys exe path /Model.ansys_exe/ is not specified!')
end

if ~exist('keep_last_batch', 'var')
    keep_last_batch = 0;
end

input_var_name = fieldnames(input_var);
result_name = cellfun(@(x) x(1:(end-4)), result_file, 'UniformOutput', 0);

if diff(cellfun(@(field) length(input_var.(field)), input_var_name)) ~= 0
    error('The dimension of the input parameters /Model.input_var.*/ mismatch, they should have equal number of elements!')
end

% collect fields and update Model
fields = {'working_dir'; 'input_file'; 'input_var'; 'input_var_name'; 'input_file_ext';
    'result_file'; 'result_name'; 'output_file'; 'licence'; 'ansys_exe'; 'keep_last_batch'};

for ii = 1:length(fields)
    upModel.(fields{ii}) = eval(fields{ii});
end

end