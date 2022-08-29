function generateMBB(file, res, dims, padding)
% Dimentions and resolution
width = dims(1);
height = dims(2);
F = StructureFactory(res, dims);

% Symmetry condition
bcsym = @(x, y) abs(x - 0) < 1e-6;
F.addBoundaryCondition(bcsym, 1, 0);

% Bottom right
bcbot = @(x, y) abs(x - width) < 1e-6;
F.addBoundaryCondition(bcbot, [1, 2], 0);

% Load
loadw = width*padding(0);
loadh = height*padding(1);
bcload = @(x, y) logical((x < loadw + 1e-6).*...
    (height - y < loadh + 1e-6));
F.addBoundaryCondition(bcload, 2, 1);

% Make material
F.make(4, file);
end