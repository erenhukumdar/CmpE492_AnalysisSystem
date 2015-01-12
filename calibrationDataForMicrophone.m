function [meanAmplitude]=calibrationDataForMicrophone(fileName)
    fid = fopen(fileName,'r');
    C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
    C = C{1};
    amplitudeValues=str2double(C(:,2));
    meanAmplitude=mean(amplitudeValues);
    
end