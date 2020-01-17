%% INPUTS

nFrames = 20;
refTime = 4;
startTime = 6;
vidLoc = uigetdir('C:\');
addpath(vidLoc)

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

vidNames = dir(fullfile(vidLoc,'*.mp4'));
nVids = length(vidNames);
tStamps = cell(nVids,2);

for i=1:nVids
    specimen = char(regexp(vidNames(i).name,'S\d\d','match'));    
    vidObj = VideoReader(vidNames(i).name);  
    vidObj.CurrentTime = refTime;
    
    tStamps{i,1} = specimen;
    tStamps{i,2} = zeros(nFrames+1,1);
    tStamps{i,2}(1) = vidObj.CurrentTime;    
    
    startFrame = ceil(startTime*vidObj.FrameRate);
    frames = ceil(linspace(startFrame,vidObj.NumFrame-1,nFrames));       
    for j=1:nFrames
        currentTime = frames(j)/vidObj.FrameRate;
        vidObj.CurrentTime = currentTime;
        tStamps{i,2}(j+1) = vidObj.CurrentTime;
    end
end