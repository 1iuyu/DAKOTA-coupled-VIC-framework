% matlab_rosen_wrapper.m
function matlab_wrapper(params,results)


fid = fopen(params,'r');
C = textscan(fid,'%n%s');
fclose(fid);

% set design variables -- could use vector notation
spf = "path\to\soil parameter file"; % 修改土壤文件地址
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
maxRetries = 10; % 最大重试次数
retryCount = 0; % 当前重试次数
ans = 1; % 初始化状态为失败
while ans ~= 0 && retryCount < maxRetries
    ans = system("wsl ./shell_script.sh");
    retryCount = retryCount + 1;
    pause(1); % 可选：在重试之间暂停一段时间
end

%% Calculate summed runoff and baseflow
retryCount1 = 0; % 当前重试次数
ans = 1; % 初始化状态为失败
while ans ~= 0 && retryCount1 < maxRetries
    ans = system("wsl /mnt/d/VIC_Routing-Fortran_version/src/rout /path/to/rout_input.txt"); % 修改汇流输入文件地址
    retryCount1 = retryCount1 + 1;
    pause(1);
end
wb=load("path\to\rout_parameter file"); % 修改汇流文件地址
q_m=wb(:,3)./35.315; % converted to m³/s
%% Load in validation data
  
valdata = "path\to\measured data file"; % 修改验证数据地址
truth = readmatrix(valdata);
q = truth(:,1);
f1 = -1*myNSE(q, q_m);
f2 = -1*myKGE(q, q_m);
% t=1:length(q_m);
% lw = 1.5;
% figure, plot(t, q_m, 'linewidth', lw)
% hold on, plot(t,q, 'linewidth', lw)
% legend('pred','obs')
% xlabel('Time')
% ylabel('Monthly streamflow (m^3/s)')
% set(gca, 'fontsize', 16)

%% WRITE results.out
fid = fopen(results,'w');
fprintf(fid,'%20.10e f1 %20.10e f2\n', f1, f2);
fclose(fid);
