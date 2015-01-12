function [meanX,meanY,meanZ]=getCalibrationDataForAccelerometer(filePath)
    fid = fopen(filePath,'r');
    C = textscan(fid, repmat('%s',1,7), 'delimiter',',', 'CollectOutput',true);
    C = C{1};
    xValues=str2double(C(:,2));
    yValues=str2double(C(:,3));
    zValues=str2double(C(:,4));
    meanX=mean(xValues);
    meanY=mean(yValues);
    meanZ=mean(zValues);
       
end