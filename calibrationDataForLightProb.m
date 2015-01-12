function [meanLightValues]=calibrationDataForLightProb(fileName)
  
    fid = fopen(fileName,'r');
    C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
    C = C{1};
    lightValues=str2double(C(:,2));
    meanLightValues=mean(lightValues);
    
end