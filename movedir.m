fileType = '*.csv';
p = pwd;
content = dir(p);
folder = {content.name};
folder = folder(isfolder(folder) & ~ismember(folder,{'.','..'}));
rootFolder = fullfile(p,folder);

for i=2:length(rootFolder)
    content = dir(fullfile(char(rootFolder(i)),fileType));
    for j=1:length(content)
        rootFile = fullfile(char(content(j).folder),...
            char(content(j).name));
        status1 = movefile(rootFile,...
            [char(rootFolder(i)),'\',num2str(i),'-',num2str(j),'.csv']);
        content = dir(fullfile(char(rootFolder(i)),fileType));
        rootFile = fullfile(char(content(j).folder),...
            char(content(j).name));
        status2 = movefile(rootFile,char(rootFolder(1)));
    end
end
