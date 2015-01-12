function readLightProb(fileName)
%     [sensorMatrix char raw] = xlsread(fileName);
    close all;
    lightCalibre=151.0;
    fid = fopen(fileName,'r');
    C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
    C = C{1};
    lightValues=smooth((str2double(C(:,2))-lightCalibre),0.1,'rloess');
    
    activityMatrix=C(:,4);
    timeStamps=C(:,3);
    figure(4);
    plot(lightValues,'LineWidth',3);
    xlabel('Sampling instance');
    ylabel('Light Density');
 
    fclose(fid);
    
end