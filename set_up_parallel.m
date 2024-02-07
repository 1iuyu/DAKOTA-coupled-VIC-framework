clc
clear;
parameter_file = "path\to\cv_params.txt";

B = read_parfile(parameter_file);

control_params = struct();

% Input files
control_params.global_param_file = strsplit_spec(B{1});
control_params.soil_param = strsplit_spec(B{2});

% Control parameters
control_params.vic_out_dir = strsplit_spec(B{3});
control_params.n_proc = str2double(strsplit_spec(B{4})); % number of processors to use
savedir = fullfile(control_params.vic_out_dir, 'parallel');
mkdir(savedir)
[~, soil_basename, ~] = fileparts(control_params.soil_param);
[~, global_basename, ~] = fileparts(control_params.global_param_file);

soils_all = dlmread(control_params.soil_param);
ncells = size(soils_all, 1);
% how many divisions to divide the soil parameter file into
n = control_params.n_proc;
nl = ceil(ncells/n); 

%% Make copies of the global parameter file

for jj=1:n

    % read the global parameter file
    fid = fopen(control_params.global_param_file, 'r');
    i = 1;
    tline = fgetl(fid);
    A{i} = tline;
    while ischar(tline)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);

    % change the soil parameter line
    A{153} = ['SOIL ' fullfile(savedir, [soil_basename, '_', num2str(jj), '.txt'])];

    % change the output directory
    A{181} = ['LOG_DIR ' control_params.vic_out_dir];
    A{182} = ['RESULT_DIR ' control_params.vic_out_dir];

    % Write cell A into txt
    sn = fullfile(savedir, [global_basename, '_', num2str(jj), '.txt']);
    
    fid = fopen(sn, 'w');
    for i=1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
        end
    end
    fclose(fid);

end

%% Subdivide the soil parameter file

for jj=1:n
     
    if jj==n
        soils_sub = soils_all((jj-1)*nl+1:ncells,:);
    else
        soils_sub = soils_all((jj-1)*nl+1:(jj-1)*nl+nl,:);
    end
    
    outname = fullfile(savedir, [soil_basename, '_', num2str(jj) '.txt']);
    precision = 4;
    write_soils(precision, soils_sub, outname, '3l');

end

