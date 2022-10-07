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
    generateMesh(namefull, resolutions(:, k), dimensions, versions{i})
end
end


function generateMesh(file, res, dim, beam_case)
w = dim(1);
h = dim(2);

F = StructureFactory(res, dim);
switch beam_case
    case 'a'
        ytol_left = 1e-6;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'b'
        ytol_left = h;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'c'
        ytol_left = h;
        ytol_right = h;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*(abs(y - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*(abs(y - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
    case 'd'
        ytol_left = 1e-6;
        ytol_right = 1e-6;
        bc1 = @(x, y) logical((abs(x - 0) < 1e-6).*...
            (abs((y - h/2) - h/2) < ytol_left));
        bc2 = @(x, y) logical((abs(x - w) < 1e-6).*...
            (abs((y - h/2) - h/2) < ytol_right));
        F.addBoundaryCondition(bc2, [1, 2], 0);
        F.addBoundaryCondition(bc1, [1, 2], 0);
        
end

% Prescribed force
fpos = @(x, y) logical((abs(x - w/2) < 1e-6).*(abs(y - h) < 1e-6));
F.addPrescribedForce(fpos, 2, -1);

% Nodes to except f

F.make(4, file);
end