%% INPUTS

prefix = '75OS';
nFrames = 20;
refTime = 4;
startTime = 6;
workingDir = pwd;
minTime = 10;

%% CREATE IMAGES
% Creates new subdirectory for each specimen where images are placed if one
% does not already exist
% Each video is pulled from the current folder (where videos should be
% stored)
% Reference video image is pulled from the video frame approx. equal to
% input reference time (in seconds)
% "Current" video images are then pulled from equally spaced frames (user 
% defined number "nFrames"), between the input "startTime" and ending at 
% second to last frame
% All videos are stored in the created or already existing subdirectory

vidNames = dir('*.mp4');
nVids = length(vidNames);
tStamps = zeros(nFrames+1,nVids);

for i=1:nVids

    specimen = char(regexp(vidNames(i).name,'S\d\d','match'));
    subDir = [specimen,'-Images'];
    switch exist(subDir,'dir')
        case 0
            mkdir(workingDir,subDir)
        otherwise
            continue
    end
    
    vidObj = VideoReader(vidNames(i).name);
    
    switch true
        case vidObj.Duration<=minTime
            continue
        otherwise
    end
    
    vidObj.CurrentTime = refTime;    
    img = readFrame(vidObj);
    fileName = [prefix,'-',specimen,'_REF.jpg'];
    fullName = fullfile(workingDir,subDir,fileName);
    imwrite(img,fullName)

    startFrame = ceil(startTime*vidObj.FrameRate);
    frames = ceil(linspace(startFrame,vidObj.NumFrame-1,nFrames));
    
    tStamps(1,i) = vidObj.CurrentTime;
    ii = 1;
    
    for j=1:nFrames
        currentTime = frames(j)/vidObj.FrameRate;
        vidObj.CurrentTime = currentTime;
        img = readFrame(vidObj);
        fileName = [prefix,'-',specimen,'_',sprintf('%02d',ii),...
            '.jpg'];
        fullName = fullfile(workingDir,subDir,fileName);
        imwrite(img,fullName)
        
        tStamps(j+1,i) = vidObj.CurrentTime;
        ii = ii+1;
    end
end