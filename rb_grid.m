function [delta, mu] = rb_grid(kernel, sigma, R, d, seed)
%RB_GRID  Generates the random grid used for generating random binding map
%
%   [DELTA, MU] = RB_GRID(KERNEL, SIGMA, R, D) returns the random grid
%   parameters for R grids of dimension D. DELTA are the widths of the grids and
%   are generated from the distribution selected by KERNEL and standard
%   deviation SIGMA. The option for KERNEL are:
%     0: normal distribution
%     1: multivariate t-Student 
%     2: t-Student
%   MU are the bias of the grids. MU is generated as uniform distribution [0,1]
%   times DELTA.
%
%   [DELTA, MU] = RB_GRID(..., SEED) set the seed of the random number generator.

    if nargin == 4
        [delta, mu] = rb_grid_mex(kernel, sigma, R, d);
    else
        [delta, mu] = rb_grid_mex(kernel, sigma, R, d, seed);
    end
