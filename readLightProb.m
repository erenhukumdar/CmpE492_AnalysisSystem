function readLightProb(folderPath,fileName,period)
%     [sensorMatrix char raw] = xlsread(fileName);
clc;

accCalibreX=calibrationDataForLightProb([folderPath,'LightSensorProbe.csv']);
timeNormalize=0;
close all;
fid = fopen([folderPath,fileName],'r');
C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
C = C{1};
lightValuesMixed=(str2double(C(:,2))-accCalibreX);
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
        lightValues=lightValuesMixed(finalPositions);
         bin=0:period:max(timeStamps);
             periodDividedPoistions=[];
            for l=1:length(bin)-1
                counter=0;
               
                for n=1:length(timeStamps)
                    if(timeStamps(n)>=bin(l) && timeStamps(n)<bin(l+1) )
                       counter=counter+1;
                       periodDividedPoistions(l,counter)=n;
                    end 
                end
            end

            
            for l=1:length(bin)-1
                tempPositions=(periodDividedPoistions(l,:)>0);
                positions=periodDividedPoistions(l,tempPositions);
                resultMatrix(l,1)=bin(l);
                resultMatrix(l,2)=j;
                resultMatrix(l,3)=mean(lightValues(positions));
                resultMatrix(l,4)=var(lightValues(positions));
                
            end
            
            
              act=cell2mat(uniqueActivities(j));
            varname=[folderPath,'ResultMatrix\',act,'\Light'];
            save(varname,'resultMatrix');
        plot(timeStamps,lightValues,'g','LineWidth',3);
        
        legend('Light Values','Location','northeast');
        grid on;
        ylabel('Light Values');
        xlabel('Time (Seconds)');
        title(['Light Sensor Values vs Time',uniqueMacIDs(i),'-',uniqueActivities(j)]);
        
        %_______________________________________Calculation rate of change____________________________
        numberOfValues=length(lightValues);
           rocX=[];
         
        rocX(1)=0;
        for k=2:numberOfValues
            rocX(k)=(lightValues(k-1)/lightValues(k))-1;
        end
        figureCounter=figureCounter+1;
        figure(figureCounter);
        plot(timeStamps,rocX,'g','LineWidth',3);
        
        legend('Light Value Changes','Location','northeast');
        grid on;
        ylabel('Rate of Change');
        xlabel('Time (Seconds)');
        title(['Light Sensor Rate of Change vs Time for',uniqueMacIDs(i),'-',uniqueActivities(j)]);
        %______________________Variance and Other Values________________________
        varX=var(lightValues);
        meanX=mean(lightValues);
        
        disp(['____________________',act,'_______________________________']);
        disp(' ');
        disp('1) Variance Values of Light Sensor');
        disp('_______________________________________________________________');
        disp(['Variance for X:',num2str(varX)]);
        disp(' ');
        disp('2) Mean Values of Accelerometer Sensor');
        disp('_______________________________________________________________');
        disp(['Mean for X:',num2str(meanX)]);
        disp(' ');
        HZeroCross=dsp.ZeroCrossingDetector;
        xNumberOfZeros=step(HZeroCross,lightValues);
        disp('3) Number of Zero Crossing');
        disp('_______________________________________________________________');
        disp(['Number of Zero Crossing for X:',num2str(xNumberOfZeros)]);
    end
end
end