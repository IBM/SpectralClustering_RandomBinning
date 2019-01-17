function [varargout] = rb_train(varargin)
%RB_TRAIN  Generates the random binding map
%
%   [OFFSET, COOR, DELTA, MU] = RB_TRAIN(A, KERNEL, SIGMA, R) returns the
%   coordinates of the nonempty bins, COOR, for the R random grids and
%   parameters of the random grids, DELTA and MU. The widths of the random grids,
%   DELTA, are generated from the distribution selected by KERNEL and standard
%   deviation SIGMA. The option for KERNEL are:
%     0: normal distribution
%     1: multivariate t-Student (default)
%     2: t-Student
%   The bias of the random grids, MU, are generated as uniform distribution [0,1]
%   times the corresponding widths. COOR(OFFSET(I):OFFSET(I+1)-1,:) are the 
%   coordinates of the nonempty bins for grid I. 
%
%   [OFFSET, COOR, DELTA, MU] = RB_TRAIN(A, KERNEL, SIGMA, R, SEED) sets the
%   seed of the random number generator used for generating the grids.
%
%   [OFFSET, COOR] = RB_TRAIN(A, DELTA, MU) returns the coordinates of the
%   nonempty bins for the grids specified the width, DELTA, and the bias, MU.
%
%   [..., PHI] = RB_TRAIN(...) returns also the sparse feature matrix.

    if nargin ~= 4 && nargin ~= 5 && nargin ~= 3
        error('Invalid number of arguments')
    end
    A = varargin{1};
    if nargin >= 4
        kernel = varargin{2};
        sigma = varargin{3};
        R = varargin{4};
        d = size(A,2);
        if nargin == 5
            seed = varargin{5};
        else
            seed = 0;
        end
        [delta, mu] = rb_grid_mex(kernel, sigma, R, d, seed);
    else
        delta = varargin{2};
        mu = varargin{3};
    end
    gen_phi = 0;
    if (nargin >= 4 && nargout == 5) || (nargin == 3 && nargout == 3)
        gen_phi = 1;
    end
    if gen_phi
        [offset, coor, phi] = rb_train_mex(A', delta, mu);
    else
        [offset, coor] = rb_train_mex(A', delta, mu);
    end

    varargout{1} = offset;
    varargout{2} = coor';
    if nargin == 3 && gen_phi
        varargout{3} = phi';
    else
        varargout{3} = delta;
        varargout{4} = mu;
        if gen_phi
            varargout{5} = phi';
        end
    end

