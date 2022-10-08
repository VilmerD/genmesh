%% Make mesh
% Dimentions in meters
dimensions = [8 1];
q = dimensions(1)/dimensions(2);

% Resolutions (making sure square elements)
yresolutions = [10 20 30 40 50 75];
xresolutions = ceil(yresolutions*q);
resolutions = [xresolutions; yresolutions];

% Version of the beam
versions = {'a'};

% Folder to save meshes in
folder = 'Projects/EfficientCA/processed_data/meshes/';

% Naming format
nameform = 'DO%s_%04ix%04i.mat';
for i = 1:numel(versions)
for k = 1:size(resolutions, 2)
    name = sprintf(nameform, versions{i}, resolutions(:, k));
    namefull = fullfile(folder, name);
    generateDuOlhoff(namefull, resolutions(:, k), dimensions, versions{i})
end
end