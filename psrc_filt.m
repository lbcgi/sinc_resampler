function [filter, y, output_length] = psrc_filt(filter, x, count, y)

  phase = filter.phase_index;
  i = filter.input_deficit;
  output_length = 1;
  while(i < count)
     y(output_length) = dot(filter.pfb(phase * filter.taps_per_phase + (1:filter.taps_per_phase)), ...
         filter.taps_per_phase, filter.history, x, i);
      output_length = output_length + 1;
      i = i + floor((phase + filter.decimation) / filter.interpolation);
      phase = mod(phase + filter.phase_index_step, filter.interpolation);
  end
  
  filter.input_deficit = i - count;
  filter.phase_index = phase;
  src_shiftin(filter.history, filter.history_length, x, count);
  
end

function dotprod = dot(a, a_length, history, b, b_last_index)
   dotprod = 0;
   i = 0;
    if(a_length > b_last_index)
        while(i < a_length - b_last_index - 1)
			dotprod = dotprod + a(i + 1) * history(b_last_index + i + 1);
            i = i + 1;
        end
    end
%     disp(a_length)
%     disp(b_last_index)
    while(i < a_length)
        dotprod = dotprod + a(i + 1) * b((i + 1 + b_last_index) - a_length + 1);
        i = i + 1;
    end
end

function a = src_shiftin(a, a_length, b, b_length)

	if (b_length > a_length)
		a = b(b_length - a_length + 1:b_length);
    else
        a(1:a_length - b_length) = a(b_length + 1:a_length);
        a(a_length - b_length + 1:a_length) = b(1:b_length);
    end
end