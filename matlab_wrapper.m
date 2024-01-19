% matlab_rosen_wrapper.m
function matlab_rosen_wrapper(params,results)


fid = fopen(params,'r');
C = textscan(fid,'%n%s');
fclose(fid);

% set design variables -- could use vector notation
spf = "path\to\soil parameter file";
files = dir(fullfile(spf, 'soil*.txt'));
for i = 1:length(files)
    soils_name = fullfile(spf, files(i).name);
    soils = load(soils_name);
    soils(:,5) = C{1}(2); % b
    soils(:,6) = C{1}(3); % ds
%     soils(:,7) = x(:,4); % dsmax

    soils(:,8) = C{1}(4); % ws
    soils(:,24) = C{1}(5); % t2
    soils(:,25) = C{1}(6); % t3

    write_soils(5, soils, soils_name, '3l');
end

%% run vic model
system("wsl ./shell_script.sh"); 
%% Calculate summed runoff and baseflow

wb=load("path\to\rout_parameter file");
q_m=wb(:,3)./35.315; %converted to m³/s
%% Load in validation data
  
valdata = "path\to\measured data file";
truth = readmatrix(valdata);
q = truth(:,1);
f = -1*myNSE(q, q_m);
t=1:length(q_m);
lw = 1.5;
figure, plot(t, q_m, 'linewidth', lw)
hold on, plot(t,q, 'linewidth', lw)
legend('pred','obs')
xlabel('Time')
ylabel('Monthly streamflow (m^3/s)')
set(gca, 'fontsize', 16)

%% WRITE results.out
fid = fopen(results,'w');
fprintf(fid,'%20.10e     f\n', f);
%fprintf(fid,'%20.10e     params\n', C{1}(2:5));

fclose(fid);
