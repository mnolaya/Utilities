%% INPUTS

prefix = '75OS';
nFrames = 20;
refTime = 4;
startTime = 6;
workingDir = pwd;

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

for i=1:nVids

    specimen = i;
    subDir = ['S',num2str(specimen),'-Images'];
    switch exist(subDir,'dir')
        case 0
            mkdir(workingDir,subDir)
        otherwise
            return
    end
    
    vidObj = VideoReader(vidNames(i).name);

    vidObj.CurrentTime = refTime;
    img = readFrame(vidObj);
    fileName = [prefix,'-',num2str(specimen),'_REF.jpg'];
    fullName = fullfile(workingDir,subDir,fileName);
    imwrite(img,fullName)

    startFrame = ceil(startTime*vidObj.FrameRate);
    frames = ceil(linspace(startFrame,vidObj.NumFrame-1,nFrames));
    
    ii = 1;
    
    for i=1:nFrames
        currentTime = frames(i)/vidObj.FrameRate;
        vidObj.CurrentTime = currentTime;
        img = readFrame(vidObj);
        fileName = [prefix,'-',num2str(specimen),'_',num2str(ii),'.jpg'];
        fullName = fullfile(workingDir,subDir,fileName);
        imwrite(img,fullName)
        ii = ii+1;
    end
end