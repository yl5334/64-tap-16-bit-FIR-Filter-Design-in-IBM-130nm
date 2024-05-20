function y = FIR(x, b)
    x_length = length(x); % number of x
    b_length = length(b); % number of b
    input_x_file = fopen('./fir_x.input', 'w'); % input file of x
    input_b_file = fopen('./fir_b.input', 'w'); % input file of b
    output_file = fopen('./fir.output', 'w'); % output file of y
    y = filter(b,1,x);
    % write the x into file
    for i = 1:x_length
        fprintf(input_x_file, "%f\n", x(i));
    end
    % write the b into file
    for j = 1:b_length
        fprintf(input_b_file, "%f\n", b(j));
    end
    % write the y into file
    for i = 1:x_length
        fprintf(output_file, "%f\n", y(i));
    end
    fclose(input_x_file);
    fclose(input_b_file);
    fclose(output_file);
end