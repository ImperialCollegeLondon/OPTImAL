function [h_inv,h_invFFT] = getInverseFilter2D( h, varargin )
% Use FFT to obtain the inverse filter that, when convolved with the
% input filter h, gives a delta function (approximately).
% Usage: h_inv = getInverseFilter2D( h );
%        h_inv = getInverseFilter2D( h, lambda );

h = h ./ sum(h(:));
hSize = size(h);
N = 512; % FFT size
lambda = 20; % regularization parameter

if (nargin > 1)
    lambda = varargin{1};
end
if (nargin > 2)
    N = varargin{2};
end

hshift = ifftshift(h);
hFFT = fftn(hshift, N);


% regFilt = [ 0.00, -0.25,  0.00 ; ...
%            -0.25,  1.00, -0.25 ; ...
%             0.00, -0.25,  0.00 ]; % regularization filter (centered difference)
% regFiltFFT = fftn(regFilt, [N,N]); % regularization filter in FFT domain
% h_invFFT = conj(hFFT) ./ ((abs(hFFT)).^2 + lambda*(abs(regFiltFFT)).^2);

regFilt1 = [  1.00, -1.00,  0.00 ];
regFilt2 = [  1.00,  0.00, -1.00 ];
regFilt3 = [  1.00; -1.00;  0.00 ];
regFilt4 = [  1.00;  0.00; -1.00 ];
regFiltFFT1 = fftn((regFilt1), N); % regularization filter in FFT domain
regFiltFFT2 = fftn((regFilt2), N); % regularization filter in FFT domain
regFiltFFT3 = fftn((regFilt3), N); % regularization filter in FFT domain
regFiltFFT4 = fftn((regFilt4), N); % regularization filter in FFT domain
h_invFFT = conj(hFFT) ./ ((abs(hFFT)).^2 + ...
                          lambda*(abs(regFiltFFT1).^2 + ...
                                  abs(regFiltFFT2).^2 + ...
                                  abs(regFiltFFT3).^2 + ...
                                  abs(regFiltFFT4).^2));


% figure; plot(fftshift(abs(h_invFFT)))

h_inv = ifftn(h_invFFT, N);
h_inv = circshift(h_inv, [floor(hSize(1)/2), floor(hSize(2)/2)]);
h_inv = h_inv(1:hSize(1),1:hSize(2));
h_inv = h_inv ./ sum(h_inv(:));
% figure; plot(h_inv);

end

