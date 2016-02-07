figure('Color',[1 1 1])
hist(data)
set(gca,'XLim',[0 10e-3])
set(gca,'YLim',[0 20])
grid on
xlabel(gca,'Spark Energy (J)','FontSize',14)
ylabel(gca,'Frequency','FontSize',14)

mean(data)*1000
std_dev = std(data)*1000
2*std_dev/mean(data)/1000*100