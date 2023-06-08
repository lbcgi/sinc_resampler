function filter = psrc_generate(interpolation, decimation, tap,  cutoff_freq)
    M_PI = 3.14159265358979323846;
    num_taps = tap * interpolation;
    tapDiv2 = tap / 2;
    ratio = tapDiv2 / num_taps;
    ratio = cutoff_freq * ratio;
    if (interpolation < decimation)
		ratio = ratio*interpolation / decimation;
    end
    
    m = num_taps - 1;
    filter.num_phases = interpolation;
    filter.taps_per_phase = ceil(num_taps / interpolation);
    pfb_size = filter.taps_per_phase * interpolation;
    filter.pfb = NaN(1, pfb_size);
    g = 1;
    if (interpolation < decimation)
        g = interpolation / decimation;
    end
    for iPhase = 0:interpolation - 1
        for iTap = 0:filter.taps_per_phase - 1
            idx = iTap * interpolation + iPhase;
            filter.pfb(iPhase * filter.taps_per_phase + filter.taps_per_phase - iTap) = ...
                (cutoff_freq * g * ((sinc(2.0*ratio*(idx - m / 2.0))) * (0.5 - 0.5 * cos(2.0 * M_PI * idx / (num_taps - 1)))));
        end
    end
    
    filter.interpolation = interpolation;
	filter.decimation = decimation;
	filter.phase_index = 0;
	filter.input_deficit = 0;
	filter.history_length = filter.taps_per_phase - 1;
	filter.phase_index_step = filter.decimation; % filter->interpolation;
    filter.history = zeros(1, filter.history_length);
end




