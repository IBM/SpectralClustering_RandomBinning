function [phi] = rb_test(A, offset, coor, delta, mu)
%RB_TEST  Generates the sparse feature matrix
%
%   PHI = RB_TEST(A, OFFSET, COOR, DELTA, MU) returns the coordinates
%   associated to the rows of A of using the random grids described by DELTA and
%   MU, that are also in COOR. The column indices of the nonzeros in PHI are the
%   indices of the coordinates in COOR.

    phi = rb_test_mex(A', delta, mu, uint64(offset), int32(coor'));
    phi = phi';
