function readGyro(folderPath,fileName,period)
%     [sensorMatrix char raw] = xlsread(fileName);
clc;
 
accCalibreX=0;
accCalibreY=0;
accCalibreZ=0;
timeNormalize=0;
close all;
fid = fopen([folderPath,fileName],'r');
C = textscan(fid, repmat('%s',1,7), 'delimiter',',', 'CollectOutput',true);
C = C{1};
xValuesMixed=(str2double(C(:,2))-accCalibreX);
yValuesMixed=(str2double(C(:,3))-accCalibreY);
zValuesMixed=(str2double(C(:,4))-accCalibreZ);
macIDMatrix=C(:,5);
activityMatrix=C(:,7);
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
        xValues=xValuesMixed(finalPositions);
        yValues=yValuesMixed(finalPositions);
        zValues=zValuesMixed(finalPositions);
        
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
                resultMatrix(l,3)=mean(xValues(positions));
                resultMatrix(l,4)=mean(yValues(positions));
                resultMatrix(l,5)=mean(zValues(positions));
                resultMatrix(l,6)=var(xValues(positions));
                resultMatrix(l,7)=var(yValues(positions));
                resultMatrix(l,8)=var(zValues(positions));
                
            end
         figureCounter=figureCounter+1;
        figure(figureCounter);
        act=cell2mat(uniqueActivities(j));
%             varname=[folderPath,'ResultMatrix\',act,'\Gyro'];
%             save(varname,'resultMatrix');
        plot(timeStamps,yValues,'g','LineWidth',3);
        hold on;
        plot(timeStamps,xValues,'c','LineWidth',3);
        hold on;
        plot(timeStamps,zValues,'r','LineWidth',3);
        hold off;
        legend('X Values','Y Values','Z Values','Location','northeast');
        grid on;
        ylabel('Axes Values');
        xlabel('Time (Seconds)');
        title(['Gyroscope Raw Values vs Time',uniqueMacIDs(i),'-',uniqueActivities(j)]);
        
        %_______________________________________Calculation rate of change____________________________
        numberOfValues=length(yValues);
        rocX=[];
        rocY=[];
        rocZ=[];
        rocX(1)=0;
        rocY(1)=0;
        rocZ(1)=0;
        for k=2:numberOfValues
            rocX(k)=((xValues(k-1)-xValues(k))/xValues(k-1));
            rocY(k)=((yValues(k-1)-yValues(k))/yValues(k-1));
            rocZ(k)=((zValues(k-1)-zValues(k))/zValues(k-1));
        end
        figureCounter=figureCounter+1;
        figure(figureCounter);
        subplot(1,3,1);
        plot(timeStamps,rocX,'g','LineWidth',3);
        legend('X Changes','Location','northeast');
        grid on;
        ylabel('Rate of Change');
        xlabel('Time (Seconds)');
        title('Gyroscope Rate of Change vs Time');
        subplot(1,3,2);
        plot(timeStamps,rocY,'c','LineWidth',3);
        legend('Y Changes','Location','northeast');
        grid on;
        ylabel('Rate of Change');
        xlabel('Time (Seconds)');
        title('Gyroscope Rate of Change vs Time');
        subplot(1,3,3);
        plot(timeStamps,rocZ,'r','LineWidth',3);
        ylabel('Rate of Change');
        xlabel('Time (Seconds)');
        title('Gyroscope Rate of Change vs Time');
        legend('Z Changes','Location','northeast');
        grid on;
        ylabel('Rate of Change');
        xlabel('Time (Seconds)');
        title(['Gyroscope Rate of Change vs Time for',uniqueMacIDs(i),'-',uniqueActivities(j)]);
        %______________________Variance and Other Values________________________
        varX=var(xValues);
        varY=var(yValues);
        varZ=var(zValues);
        meanX=mean(xValues);
        meanY=mean(yValues);
        meanZ=mean(zValues);
        
        disp(['____________________',act,'_______________________________']);
        disp(' ');
        disp('1) Variance Values of Gyroscope Sensor');
        disp('_______________________________________________________________');
        disp(['Variance for X:',num2str(varX)]);
        disp(['Variance for Y:',num2str(varY)]);
        disp(['Variance for Z:',num2str(varZ)]);
        disp(' ');
        disp('2) Mean Values of Gyroscope Sensor');
        disp('_______________________________________________________________');
        disp(['Mean for X:',num2str(meanX)]);
        disp(['Mean for Y:',num2str(meanY)]);
        disp(['Mean for Z:',num2str(meanZ)]);
        disp(' ');
        HZeroCross=dsp.ZeroCrossingDetector;
        xNumberOfZeros=step(HZeroCross,xValues);
        yNumberOfZeros=step(HZeroCross,yValues);
        zNumberOfZeros=step(HZeroCross,zValues);
        disp('3) Number of Zero Crossing');
        disp('_______________________________________________________________');
        disp(['Number of Zero Crossing for X:',num2str(xNumberOfZeros)]);
        disp(['Number of Zero Crossing for Y:',num2str(yNumberOfZeros)]);
        disp(['Number of Zero Crossing for Z:',num2str(zNumberOfZeros)]);
    end
end
end