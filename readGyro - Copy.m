function readGyro(fileName)
%     [sensorMatrix char raw] = xlsread(fileName);
    accCalibreX=0;
    accCalibreY=0;
    accCalibreZ=0;
    close all;
    fid = fopen(fileName,'r');
    C = textscan(fid, repmat('%s',1,6), 'delimiter',',', 'CollectOutput',true);
    C = C{1};
    xValues=smooth((str2double(C(:,2))-accCalibreX),0.1,'rloess');
    yValues=smooth((str2double(C(:,3))-accCalibreY),0.1,'rloess');
    zValues=smooth((str2double(C(:,4))-accCalibreZ),0.1,'rloess');
    activityMatrix=C(:,6);
    timeStamps=C(:,5);
    figure(1);
    plot(xValues,'g','LineWidth',3);
    hold on;
    plot(yValues,'c','LineWidth',3);
    hold on;
    plot(zValues,'r','LineWidth',3);
    hold off;
    legend('Changes on X','Changes on Y','Changes on Z','Location','southeast');
    grid on;
%     figure(2);
%     plot3(xValues,yValues,zValues);
%     grid on;
%     xlabel('X Axis');
%     ylabel('Y Axis');
%     zlabel('Z Axis');
%     set(gca, 'XColor', 'r', 'YColor', [0 0.5 0.5], 'ZColor', 'y')
%     fclose(fid);
    
end