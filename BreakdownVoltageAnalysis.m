%% Initialize
clc
clearvars
close('all')

% Initialize the waitbars
multiWaitbar('CloseAll');
multiWaitbar('Loading Data',0,'Color',[0 0 1]);

%% Inputs

Input(1).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\4_19_2015';
Input(1).TestPoints                         = 26:50;
Input(1).MarkerSize                         = 10;
Input(1).MarkerFaceColor                    = 'k';
Input(1).MarkerEdgeColor                    = 'k';
Input(1).MarkerType                         = 's';
Input(1).LegendEntry                        = '1mm Gap, High-Res Acq. Mode';
Input(1).OscilloscopeChannels               = [1 2 3];
Input(1).VoltageChannel                     = 2;
Input(1).InputBiasCurrentVoltageRefFileName = '';
Input(1).InputBiasCurrentVoltageRefChannel  = [];
Input(1).InvertInputBiasCurrentVoltageRef   = [];

Input(2).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\4_19_2015';
Input(2).TestPoints                         = 51:64;
Input(2).MarkerSize                         = 10;
Input(2).MarkerFaceColor                    = 'y';
Input(2).MarkerEdgeColor                    = 'k';
Input(2).MarkerType                         = 's';
Input(2).LegendEntry                        = '1.5mm Gap, High-Res Acq. Mode';
Input(2).OscilloscopeChannels               = [1 2 3];
Input(2).VoltageChannel                     = 2;
Input(2).InputBiasCurrentVoltageRefFileName = '';
Input(2).InputBiasCurrentVoltageRefChannel  = [];
Input(2).InvertInputBiasCurrentVoltageRef   = [];

Input(3).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\4_19_2015';
Input(3).TestPoints                         = 65:89;
Input(3).MarkerSize                         = 10;
Input(3).MarkerFaceColor                    = 'g';
Input(3).MarkerEdgeColor                    = 'k';
Input(3).MarkerType                         = 's';
Input(3).LegendEntry                        = '1.5mm Gap, 2GS/s, Normal Acq. Mode';
Input(3).OscilloscopeChannels               = [1 2 3];
Input(3).VoltageChannel                     = 2;
Input(3).InputBiasCurrentVoltageRefFileName = '';
Input(3).InputBiasCurrentVoltageRefChannel  = [];
Input(3).InvertInputBiasCurrentVoltageRef   = [];

Input(4).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\4_19_2015';
Input(4).TestPoints                         = 165:170;
Input(4).MarkerSize                         = 10;
Input(4).MarkerFaceColor                    = 'b';
Input(4).MarkerEdgeColor                    = 'k';
Input(4).MarkerType                         = 's';
Input(4).LegendEntry                        = '2mm Gap, 1GS/s, Normal Acq. Mode';
Input(4).OscilloscopeChannels               = [1 2 3];
Input(4).VoltageChannel                     = 2;
Input(4).InputBiasCurrentVoltageRefFileName = '';
Input(4).InputBiasCurrentVoltageRefChannel  = [];
Input(4).InvertInputBiasCurrentVoltageRef   = [];

Input(5).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\4_19_2015';
Input(5).TestPoints                         = 171:195;
Input(5).MarkerSize                         = 10;
Input(5).MarkerFaceColor                    = 'm';
Input(5).MarkerEdgeColor                    = 'k';
Input(5).MarkerType                         = 's';
Input(5).LegendEntry                        = '2mm Gap, 2GS/s, Normal Acq. Mode';
Input(5).OscilloscopeChannels               = [1];
Input(5).VoltageChannel                     = 1;
Input(5).InputBiasCurrentVoltageRefFileName = '';
Input(5).InputBiasCurrentVoltageRefChannel  = [];
Input(5).InvertInputBiasCurrentVoltageRef   = [];

Input(6).HomeFolder                         = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_14_2015';
Input(6).TestPoints                         = 2:201;
Input(6).MarkerSize                         = 10;
Input(6).MarkerFaceColor                    = 'w';
Input(6).MarkerEdgeColor                    = 'k';
Input(6).MarkerType                         = 's';
Input(6).LegendEntry                        = '2mm Gap, High-Resolution Mode, HV Probe Clamp';
Input(6).OscilloscopeChannels               = [1 2 3 4];
Input(6).VoltageChannel                     = 4;
Input(6).InputBiasCurrentVoltageRefFileName = 'C:\Users\Jim Cornacchio\Documents\Dissertation\Spark Generator Design\Triple HV Switch Board Tests\7_14_2015\Raw Oscilloscope Data\tp_0.bin';
Input(6).InputBiasCurrentVoltageRefChannel  = [2];
Input(6).InvertInputBiasCurrentVoltageRef   = true;

%% Load and plot the data

FigHandle   = figure('Color',[1 1 1],...
                        'Position',[238 367 1244 516]);
AxesHandle  = gca;
hold(AxesHandle,'on')

% Calculate the total number of points to load
TotalNumberOfPoints = length([Input.TestPoints]);

% Initialize a counter that will increment for each point that has been
% loaded.
counter = 0;

for loop = 1:length(Input)
    
    % Preallocate an array to hold the breakdown voltage data
    BreakdownVoltageArray = NaN(length(Input(loop).TestPoints),1);
    
    for loop2 = 1:length(Input(loop).TestPoints)
        % Load the data from the file
        try
            OscilloscopeData = importAgilentBin(fullfile(Input(loop).HomeFolder,'Raw Oscilloscope Data',['tp_' int2str(Input(loop).TestPoints(loop2)) '.bin']),Input(loop).OscilloscopeChannels);
        catch
            % Warn the user that an error was encountered!
            warn = warndlg(['File ' fullfile(Input(loop).HomeFolder,'Raw Data',['tp_' int2str(Input(loop).TestPoints(loop2)) '.bin']) 'could not be read. There may have been an error writing data from the oscilloscope.'],'WARNING!');
            continue
        end
        
        if ~isempty(Input(loop).InputBiasCurrentVoltageRefFileName)
           % Load the input bias current offset data
            InputBiasCurrentVoltageRefData	= importAgilentBin(Input(loop).InputBiasCurrentVoltageRefFileName,[1 2 3 4]);
            InputBiasCurrentVoltageOffset	= mean(InputBiasCurrentVoltageRefData(Input(loop).InputBiasCurrentVoltageRefChannel).dataVector);

            if Input(loop).InvertInputBiasCurrentVoltageRef
                InputBiasCurrentVoltageOffset = -1*InputBiasCurrentVoltageOffset;
            end
        
        else
            InputBiasCurrentVoltageOffset = 0;
        end
        
        % Increment the counter
        counter = counter+1;
        
        % Calculate the maximum voltage
        BreakdownVoltageArray(loop2) = max(OscilloscopeData(Input(loop).VoltageChannel).dataVector)-InputBiasCurrentVoltageOffset;
        
        % Update the waitbar
        multiWaitbar('Loading Data',counter/TotalNumberOfPoints);
                
    end
    
    % Plot the data
    plot(loop*ones(length(Input(loop).TestPoints),1),BreakdownVoltageArray,...
            'LineStyle','none',...
            'MarkerFaceColor',Input(loop).MarkerFaceColor,...
            'Marker',Input(loop).MarkerType,...
            'MarkerEdgeColor',Input(loop).MarkerEdgeColor,...
            'MarkerSize',Input(loop).MarkerSize);    
    
end

% Set the legend
legend({Input.LegendEntry},'FontSize',12,'Location','NorthEastOutside')

% Set axes properties
set(AxesHandle,'FontSize',14)
xlabel(AxesHandle,'Data Set','FontSize',16)
ylabel(AxesHandle,'Breakdown Voltage','FontSize',16)
set(AxesHandle,'XTick',0:1:loop+1)
set(AxesHandle,'XLim',[0 loop+1])
grid(AxesHandle,'on')

%% Clean-up
clc
clearvars

multiWaitbar('CloseAll');

