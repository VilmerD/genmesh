function generateDuOlhoff(file, dim, res, beam_case, padding_pde)
% GENERATEDUOLHOFF generates the mesh for the double clamped 
% beam according to the paper by Du and Olhoff. 
%
% GENERATEDUOLHOFF(file, dim, res, beam_case) 
% generates the meshwhere file is the string of the file where the data
% should be stored, dim are the dimentions of the beam (width x height)
% res is the number of elements in x and y and beam_case is a character
% which determines the boundary conditions.
%
% GENERATEDUOLHOFF(file, dim, res, beam_case, padding_pde)
% also adds padding around the boundary conditions and applied force
% to allow for a pde filter. 
% 

% Sort res in ascending order to make bandwidth smaller
[res, I] = sort(res, 'ascend');
dim = dim(I);

[enod, dof, edof, coord, boundary_nodes, ...
    I_mat, J_mat, I_img, J_img] = makeMatQ4(dim, res);

% Repermute indices back
coord = coord(:, I);
dim = dim(I);

cx = coord(:, 1); w = dim(1);
cy = coord(:, 2); h = dim(2);

% Boundary conditions
switch lower(beam_case)
    case 'a'
        YR = 100*eps;
        YL = 100*eps;
    case 'b'
        YR = 100*eps;
        YL = h/2;
    case 'c'
        YR = h/2;
        YL = h/2;
end

% Nodes with prescribed (zero) displacement at x = w
nodes_prescribed_right = logical(...
    (abs(cx - w) < eps).*...
    (abs(cy - h/2) < YR)...
    );
% Nodes with prescribed (zero) displacement at x = 0
nodes_prescribed_left = logical(...
    (abs(cx - 0) <= eps).*...
    (abs(cy - h/2) <= YL)...
    );

% Convert nodes to degrees of freedom and assemble bc-matrix
dp = [dof(nodes_prescribed_right, :), dof(nodes_prescribed_left, :)]';
bc = [dp, zeros(size(dp))];

% Prescribed force
nodes_prescribed_force = logical(...
    (abs(cx - w/2) < eps).*...
    (abs(cy - h) < eps)...
    );
df = dof(nodes_prescribed_force, 2)';
F = [df, ones(size(df))];

% Nodes with homogeneous neumann conditions
if nargin < 5; padding_pde = 0; end
natural_nodesA = [];
natural_nodesA = [natural_nodesA; find((abs(cy - h/2) <= h*padding_pde).*(abs(cx - w) <= 100*eps))];
natural_nodesA = [natural_nodesA; find((abs(cy - h/2) <= h*padding_pde).*(abs(cx - 0) <= 100*eps))];

% Nodes where force is applied
natural_nodesB = [natural_nodesA; find((abs(cx - w/2) <= w*padding_pde).*(abs(cy - h) <= 100*eps))];

% Nodes with robin conditions
robin_nodesA = setdiff(boundary_nodes, natural_nodesA);
robin_nodesB = setdiff(boundary_nodes, natural_nodesB);

% Save data to file
save(file, 'enod', 'dof', 'edof', 'coord', 'boundary_nodes', 'bc', 'F', ...
    'natural_nodesA', 'natural_nodesB', 'robin_nodesA', 'robin_nodesB', ...
    'I_mat', 'J_mat', 'I_img', 'J_img');
end