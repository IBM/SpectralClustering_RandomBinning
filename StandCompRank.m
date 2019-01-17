function y = StandCompRank(x)
%
%   Calculate the STANDARD COMPETITION RANKINGS of vector x (in ascending order)
%
%   For details regarding ranking methodologies: http://en.wikipedia.org/wiki/Ranking
%
%
% INPUT
%   The user supplies the data vector x.
%
%
% EXAMPLE 1:
%   x = [32 73 46 32 95 73 87 73 22 69 13 57];
%   y = StandardCompetitionRankings(x);
%   sortrows([x', y], 1)
%   ans =
%            13     1
%            22     2
%            32     3
%            32     3
%            46     5
%            57     6
%            69     7
%            73     8
%            73     8
%            73     8
%            87    11
%            95    12
%
%
% EXAMPLE 2:
%   x = ceil(10000 * rand(10000000, 1));
%   tic;
%   y = StandardCompetitionRankings(x);
%   toc
%   Elapsed time is 15.802000 seconds.
%
%
% EXAMPLE 3:
%   x = rand(10000000, 1);
%   tic;
%   y = StandardCompetitionRankings(x);
%   toc
%   Elapsed time is 8.211000 seconds.
%
%
%   This code has a poor performance when x is a vector with a huge Frequency Table
%   when frequencies are generally low and there exists at least one value of x with
%   frequency more than one.
%
%
%   This code is not particularly elegant nor efficient: if anyone finds out a more
%   efficient and elegant way to obtain the same result, I would greatly appreciate
%   if you could share it.
%
%
%   I acknowledge the beautiful solution for calculating Frequency Tables provided by
%   Mukhtar Ullah (mukhtar.ullah@informatik.uni-rostock.de) on the 28th of December 2004
%   http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=6631&objectType=file
%
%
%-*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-*%
%                                                                                               %
%            Author: Liber Eleutherios                                             %
%            E-Mail: libereleutherios@gmail.com                             %
%            Date: 8 April 2008                                                       %
%                                                                                               %
%-*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-* -*-*%
% 
% 
% 

% Prepare data
ctrl = isvector(x) & isnumeric(x);
if ctrl
  x = x(:);
  x = x(~isnan(x) & ~isinf(x));
else
  error('x is not a vector of numbers! The Standard Competition Ranking could not be calculated')
end
% Find the Frequency Distribution
[y, ind] = sort(x);
FreqTab(:, 1) = y([find(diff(y)); end]);
N1 = length(x);
N2 = length(FreqTab(:, 1));
if N1 == N2
  y(ind) = 1:N1;
  return
end
FreqTab(:, 2) = histc(y, FreqTab(:, 1));
% Find the rankings
y = (1:N1)';
k = 1;
for i = 1:N2
  if FreqTab(i, 2) > 1
    y(k:(k + FreqTab(i, 2) - 1)) = k;
  end
  k = k + FreqTab(i, 2);
end
y = sortrows([y, ind], 2);
y(:, 2) = [];
