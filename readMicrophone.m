function readMicrophone(fileName)
%     [sensorMatrix char raw] = xlsread(fileName);
close all;
micCalibre=calibrationDataForMicrophone('D:\EclipseWorkSpace\GoogleGlassServer\SensorData\Calibration\SoundAmplitude.csv');
fid = fopen(fileName,'r');
C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
C = C{1};
amplitudeValuesMixed=str2double(C(:,2))-micCalibre;
macIDMatrix=C(:,3);
activityMatrix=C(:,5);
timeStampsRaw=str2double(C(:,1));
timeNormalize=timeStampsRaw(1);
timeStampsMixed=timeStampsRaw-timeNormalize;
uniqueMacIDs=unique(macIDMatrix);
figureCounter=0;
for i=1:length(uniqueMacIDs)
    
    
    filteredActivities=find(strcmp(macIDMatrix,uniqueMacIDs(i)));
    macFiliteredActivities=activityMatrix(filteredActivities);
    uniqueActivities=unique(macFiliteredActivities);
    for j=1:length(uniqueActivities)
        
        figureCounter=figureCounter+1;
        filteredValues=find(strcmp(activityMatrix,uniqueActivities(j)));
        finalPositions=intersect(filteredValues,filteredActivities);
        timeStamps=timeStampsMixed(finalPositions);
        amplitudeValues=amplitudeValuesMixed(finalPositions);
        figure(figureCounter);
        plot(timeStamps,amplitudeValues,'LineWidth',3);
        xlabel('Time (Seconds)');
        ylabel('Amplitude');
        title(['Amplitude Values vs Time',uniqueMacIDs(i),'-',uniqueActivities(j)]);
    end
end
end