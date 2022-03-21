%% Spherial Parameterization of genus-0 surface
% It is a non-official implementation of the paper:   
% Praun, Emil, and Hugues Hoppe. "Spherical parametrization and remeshing." ACM Transactions on Graphics (TOG) 22.3 (2003): 340-349.
%
% Note that the parameterization is not conformal. 
%
% This code runs only on Windows and requires Matlab.
%
% See the file readme.md for more details.
%
% Copyright Hamid Laga 
% Date: 2022/03/20
%
% This code uses some external libraries, which are included here but
% credit should be given to the original authors:
% - kdtree library, developed by Andrea Tagliasacchi ata2@cs.sfu.ca
% - Progressive mesh structure, which are part of OpenMesh (https://www.graphics.rwth-aachen.de/software/openmesh/) 
%   Please refer to www.openmesh.org and https://www.graphics.rwth-aachen.de/software/openmesh/license/ for the license and copyright
%
%%
clear all;
close all;

%% Adding the necessary paths
addpath('./meshIO');
addpath('./TriangleRayIntersection');
addpath('./kdtree');

pDir = '.\';
dataDir   = [pDir 'sample_data\'];

%% Settung the parameters
toVisualize = 1;   % set it to 0 if you don't want to plot the figures
toSave      = 1;   % set it to 0 if you don't want to save the results

isSurfaceAnnotated = 0; % set it to 0 if surfaces are not annotated with landmarks
annotationDir      = [pDir 'Annotation\']; % only  needed if isSurfaceAnnotated = 1

% Parameters of the spherical parameterization algorithm
baseMeshSize = 20;					% Size of the base mesh
tutteMapIterations = 15000;         % no of iterations for the initial tutte mapping
tutteMapDelta   = 0.0001;           % step size for the tutte mapping
finalResolution = 5000;             % -1 will process all the vertices (maybe slow)
                                    % You can also specify the desired
                                    % mesh resolution, e.g., 5000 vertices
                                    % if the no of vertices exceeds
                                    % 5000, the pgm might be slow in
                                    % that case set finalResolution = 5000 (or any other value you want)
                                    
N = 256;                            % Desired spherical resolution. This will generate spherical maps of 256 x 256
                                    
%% Run over all the 3D models in the the folder
fnames = dir([dataDir, '*.off']);
nfiles = numel(fnames);

for fix = 1:nfiles,
    
    off_fname = fnames(fix).name; 
    obj_fname = [off_fname(1:end-3) 'obj'];        

    %% 1. Convert all the mesh into .obj (skip this step if the original mesh is in obj)
    %     This is required by the code that creates the progressive meshes
    
    % load the mesh
    shape   = loadoff([dataDir off_fname]);         % the mesh
    save2OBJ(shape, [dataDir obj_fname]);

    %% 2. Creates progressive mesh structure (it is saved with the same name as the mesh but with extension .pm)
    %     This will create .pm files, which you can delete later (if you
    %     don't need them)
    fname  = obj_fname;
    disp('Creating progressive mesh ...');
    status = dos(['ProgressiveMesh\mkbalancedpm.exe ' dataDir  fname]);
    
    %% 3. Visualize the progressive mesh
    %  Uncomment the following lines if you would like to visualize the
    %  created progressive meshes
    
    % Use shift+ to add vertices and shift- to remove vertices
    % pm_fname = [fname(1:end-3) 'pm'];
    % dos(['ProgressiveMesh\ProgViewer.exe ' dataDir  pm_fname]);


    %% 4. Embed the vertices into a sphere
    pm_fname = [fname(1:end-3) 'pm'];
    
    disp('Embedding the mesh vertices onto the sphere ...');
    commandLineParams = [dataDir  pm_fname ' ' num2str(baseMeshSize) ' ' num2str(tutteMapIterations) ' ' num2str(tutteMapDelta) ' ' num2str(finalResolution)];
    status = dos(['ProgressiveSphericalParameterizer\ProgressiveSphericalParametrizer.exe ' commandLineParams]);

    %% 5. create the sphererical map
    disp('Creating the spherical surface ...');
    fname   = [pm_fname '_pm.off']; 	      % Original mesh
    s_fname = [pm_fname '_sph.off']; 	      % this is the mesh vertices embedded onto the sphere
    % hks_fname    = [name '_pm_hks.mat'];    % Landmarks

    sphmap_fname     = [fname(1:end - 7) '.mat']; % this is S^2 \to R^3, i.e., the output

    if exist([dataDir sphmap_fname], 'file') == 2
        continue;
    end

    if exist([dataDir s_fname], 'file') ~= 2
        continue;
    end

    shape   = loadoff([dataDir fname]);         % the mesh
    s_shape = loadoff([dataDir s_fname]);       % the spherical mesh

    %% Generate the spherical map M (you may ignore fIdx)
    [M, fIdx] = makeSphericalMap(shape, s_shape, N);

    %% 6. map the surface annotations (if provided) to the sphere
    if isSurfaceAnnotated,
        disp('Embedding the annotations ...');
        annotation_fname = [annotationDir off_fname(1:end-4) '.seg'];
        faceLabels = load(annotation_fname);

        shape   = loadoff([dataDir off_fname]);         % the mesh
        L       = labelSphericalSurface(M, shape, faceLabels);
    end

    if toVisualize,
        figure(10), clf;
        if isSurfaceAnnotated,
            surface(squeeze(M(:, :, 1)), squeeze(M(:, :, 2)), squeeze(M(:, :, 3)), L+1); 
        else
            surface(squeeze(M(:, :, 1)), squeeze(M(:, :, 2)), squeeze(M(:, :, 3)) ); 
        end
        axis equal; cameramenu;
        hold on;
    end

    %% 5. save the outcome
    if toSave,
       if isSurfaceAnnotated,
           save([dataDir sphmap_fname], 'M', 'L'); % Save the embedded landmarks L
       else
           save([dataDir sphmap_fname], 'M');
       end
    end
    
    disp('Press any key to process the next mesh ...')
    pause
end


