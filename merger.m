function merger(scenarioName,folderPath)
fullPath=[folderPath,'ResultMatrix\',scenarioName,'\'];
Files=dir(fullPath);
numberOfFiles= numel(Files);
mainMatrix=[];
counter=0;
for i=1:numberOfFiles
    if ((strcmp(Files(i).name,'.')==0 ) && (strcmp(Files(i).name,'..')==0))
        counter=counter+1;
        sensorMatrix=load([fullPath,Files(i).name], '-mat');
        if (isempty(mainMatrix)==1) 
            mainMatrix=horzcat(mainMatrix,sensorMatrix.resultMatrix);
        else
            [x,y]=size(sensorMatrix.resultMatrix);
            mainMatrix=horzcat(mainMatrix,sensorMatrix.resultMatrix(:,3:y));
        end
    end
end
 varname=[folderPath,'MainMatrices\',scenarioName];
 save(varname,'mainMatrix');

end