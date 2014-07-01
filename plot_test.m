file2 = load('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_2.mat');
file3 = load('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_9.mat');
file4 = load('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_1.mat');

file5 = load('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_5.mat');
file6 = load('C:\Users\Jim Cornacchio\Documents\Dissertation\HighSpeedVideoProcessing\SchlierenVideoProcessing\ProcessedData\ProcessedData_GT2011_6.mat');
% figure
% hold on
% grid on
% xlabel('Time (ms)')
% ylabel('Upper Spark Radius, Vertical Centerline')
% plot(file2.ProcessedData.Time,file2.ProcessedData.UpperCenterLineRadius_cm,'.b');
% plot(file3.ProcessedData.Time,file3.ProcessedData.UpperCenterLineRadius_cm,'.m');
% plot(file4.ProcessedData.Time,file4.ProcessedData.UpperCenterLineRadius_cm,'.k');
% plot(file5.ProcessedData.Time,file5.ProcessedData.UpperCenterLineRadius_cm,'.g');
% plot(file6.ProcessedData.Time,file6.ProcessedData.UpperCenterLineRadius_cm,'.r');
% figure
% hold on
% xlabel('Time (ms)')
% ylabel('Lower Spark Radius, Vertical Centerline')
% plot(file2.ProcessedData.Time,file2.ProcessedData.LowerCenterLineRadius_cm,'.b');
% plot(file3.ProcessedData.Time,file3.ProcessedData.LowerCenterLineRadius_cm,'.m');
% plot(file4.ProcessedData.Time,file4.ProcessedData.LowerCenterLineRadius_cm,'.k');
% plot(file5.ProcessedData.Time,file5.ProcessedData.LowerCenterLineRadius_cm,'.g');
% plot(file6.ProcessedData.Time,file6.ProcessedData.LowerCenterLineRadius_cm,'.r');
% grid on

figure
hold on
grid on
xlabel('Time (ms)')
ylabel('Spark Kernel Upper Propagation Speed (cm/s), Vertical Centerline')
plot(file2.ProcessedData.TimeFirstDerivative,file2.ProcessedData.UpperCenterline_cm_per_sec_drdt,'.b');
plot(file3.ProcessedData.TimeFirstDerivative,file3.ProcessedData.UpperCenterline_cm_per_sec_drdt,'.m');
plot(file4.ProcessedData.TimeFirstDerivative,file4.ProcessedData.UpperCenterline_cm_per_sec_drdt,'.k');
plot(file5.ProcessedData.TimeFirstDerivative,file5.ProcessedData.UpperCenterline_cm_per_sec_drdt,'.g');
plot(file6.ProcessedData.TimeFirstDerivative,file6.ProcessedData.UpperCenterline_cm_per_sec_drdt,'.r');
figure
hold on
xlabel('Time (ms)')
ylabel('Spark Radius Lower Propagation Speed (cm/s), Vertical Centerline')
plot(file2.ProcessedData.TimeFirstDerivative,file2.ProcessedData.LowerCenterline_cm_per_sec_drdt,'.b');
plot(file3.ProcessedData.TimeFirstDerivative,file3.ProcessedData.LowerCenterline_cm_per_sec_drdt,'.m');
plot(file4.ProcessedData.TimeFirstDerivative,file4.ProcessedData.LowerCenterline_cm_per_sec_drdt,'.k');
plot(file5.ProcessedData.TimeFirstDerivative,file5.ProcessedData.LowerCenterline_cm_per_sec_drdt,'.g');
plot(file6.ProcessedData.TimeFirstDerivative,file6.ProcessedData.LowerCenterline_cm_per_sec_drdt,'.r');
grid on

