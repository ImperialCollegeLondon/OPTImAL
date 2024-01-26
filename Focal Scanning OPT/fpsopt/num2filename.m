function filename=num2filename(num,basename,varargin)
% num2filename
% Returns a string with a numbered filename.
% Usage:
%	filename=num2filename(num,basename)
%	Replaces % in basename with num.
%
%	filename=num2filename(num,basename,ndigit)
%	Replaces % in basename with num, and adds leading zeros if necessary,
%	such that the number has ndigit. (default is to not add leading zeros,
%	i.e., ndigit=[])
%
%	filename=num2filename(num,basename,ndigit,numstr)
%	Same as above but replaces the string numstr with the number.
%
% Examples:
%	> filename = num2filename(3, 'foo%.tif')
%	filename =
%	foo3.tif
%	> filename=num2filename(3,'foo%.tif',3)         
%	filename =
%	foo003.tif
%	> filename=num2filename(3,'fooREP.tif',[],'REP')         
%	filename =
%	foo3.tif
%
%	Michael Liebling, May 17 2004
%	liebling@caltech.edu
switch nargin
	case 2,
		numstr='%';
		ndigit=[];
	case 3,
		numstr='%';
		ndigit=varargin{1};
	case 4,
		ndigit=varargin{1};
		numstr=varargin{2};
	otherwise,
		error('Wrong number of arguments')
end
idx=findstr(basename,numstr);
if isempty(idx)
	error('Could not find the string to replace by a number in the basename.')
end
filename=[basename(1:idx-1) ndigitnum2str(num,ndigit) basename(idx+length(numstr):end)];
end % end of num2filename.m
