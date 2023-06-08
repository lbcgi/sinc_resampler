clear;
filter = psrc_generate(1, 2, 3, 100);
Len = 1000;
x = randn(Len, 1);
y = NaN(round(Len/2), 1);
[filter, y, len] = psrc_filt(filter, x, Len, y);