function [enod, dof, edof, coord, boundary_nodes, ...
    I_mat, J_mat, I_img, J_img] = makeMatQ4(dim, res)
nx = res(1);
ny = res(2);
nelm = nx*ny;
nnod = (nx + 1)*(ny + 1);
n = 1:nnod;

% Compute enod
edge1 = 1           :1          :(nx + 1);
edge2 = (nx + 1)    :(nx + 1)   :nnod;
edge3 = nnod - nx   :1          :nnod;
edge4 = 1           :(nx + 1)   :nnod - nx;
n1 = setdiff(n, union(edge2, edge3))';
n2 = setdiff(n, union(edge3, edge4))';
n3 = setdiff(n, union(edge4, edge1))';
n4 = setdiff(n, union(edge1, edge2))';
enod = [(1:nelm)' n1 n2 n3 n4];

% Compute edof
dof = [1:2:2*nnod; 2:2:2*nnod]';
dofx = dof(:, 1);   edofx = dofx(enod(:, 2:end));
dofy = dof(:, 2);   edofy = dofy(enod(:, 2:end));
edof = (1:nelm)';
edof(:, 2:2:9) = edofx;
edof(:, 3:2:9) = edofy;

% Compute coordinate matrix
xcoord = repmat(linspace(0, dim(1), (nx + 1)), 1, (ny + 1));
ycoord = reshape(repmat(linspace(0, dim(2), (ny + 1)), (nx + 1), 1), 1, []);
coord = [xcoord', ycoord'];

boundary_nodes = [];
boundary_nodes = [boundary_nodes; find(coord(:, 1) == 0)];
boundary_nodes = [boundary_nodes; find(coord(:, 1) == dim(1))];
boundary_nodes = [boundary_nodes; find(coord(:, 2) == 0)];
boundary_nodes = [boundary_nodes; find(coord(:, 2) == dim(2))];
boundary_nodes = unique(boundary_nodes);

% Index vectors for sparsity pattern
I_mat = reshape(kron(edof(:, 2:end), ones(2*4, 1))', [], 1);
J_mat = reshape(kron(edof(:, 2:end), ones(1, 2*4))', [], 1);

% Index vectors for plot
J_img = reshape(kron(1:nx, ones(ny, 1))', [], 1);
I_img = reshape(kron(1:ny, ones(1, nx)), [], 1);
end