clear;
clc;

% Target Function
target = 'sigmoid';
if strcmp(target , 'tanh')
    input = [-3: 0.001: 3];
    real_output = tanh(input);
elseif strcmp(target , 'sigmoid')
    input = [-3.5: 0.001: 3.5];
    % Entire Range: 
    %    input = [-3.5: 0.001: 3.5];
    % inlier: 
    %    input = [-3: 0.001: 3];
    % outlier:
    %     input0 = [-5.5: 0.001: -1.5];
    %     input1 = [ 1.5: 0.001:  5.5];
    %     input = [input0, input1];
    real_output = sigmoid(input);
elseif strcmp(target , 'sigmoid_gelu')
    input = [-4: 0.001: 4];
    real_output = sigmoid(1.702*input);
end

% Hyper Parameters
a0 = 0.0; a1 = 0.0; r = 0.0;
if strcmp(target , 'tanh')
    k0 = 1;
    b0 = 1.0; b1 = 1.0;
    c0 = 0.0; c1 = 0.0;
elseif strcmp(target , 'sigmoid')
    k0 = 0.5;
    b0 = 0.5; b1 = 0.5;
    c0 = 0.5; c1 = 0.5;
elseif strcmp(target , 'sigmoid_gelu')
    k0 = 0.5;
    b0 = 0.5; b1 = 0.5;
    c0 = 0.5; c1 = 0.5;
end

% Approximation Function
r = -1; dist_min = 1e6;
a0_min = 0; a1_min = 0; k1_min = 0;
for a0 = 1.0: 0.1: 4.0
    fprintf("(%f/4.0)\n", a0);
    for a1 = a0 : 0.1 : 6.0
        for k1 = 0.01 : 0.01 : k0
%             fprintf("(%f/4.5, %f/6.0, %f/%f)\n", a0, a1, k1, k0);
            approx_output = approx_func(input, k0, k1, a0, a1, b0, b1, c0, c1, r);
%             dist = sum(((real_output - approx_output)./real_output) ...
%                      .*((real_output - approx_output)./real_output));
            dist = sum(((real_output - approx_output)) ...
                     .*((real_output - approx_output)));
            if (dist < dist_min)
                dist_min = dist;
                a0_min = a0;
                a1_min = a1;
                k1_min = k1;
            end
        end
    end
end
a0_typ = a0_min;
a1_typ = a1_min;
k1_typ = k1_min;
step = 10;
dist_min = 1e6;
a0_min = 0;
a1_min = 0;
k1_min = 0;
for s = 1:step
    for a0 = a0_typ - power(0.1, s) : 0.1 * power(0.1, s) : a0_typ + power(0.1, s)
        for a1 = a1_typ - power(0.1, s) : 0.1 * power(0.1, s) : a1_typ + power(0.1, s)
            for k1 = k1_typ - power(0.1, s) : 0.1 * power(0.1, s) : k1_typ + power(0.1, s)
                fprintf("(%f/%f, %f/%f, %f/%f)\n", a0, a0_typ + power(0.1, s), ...
                                                    a1, a1_typ + power(0.1, s), ...
                                                    k1, k1_typ + power(0.1, s));
                approx_output = approx_func(input, k0, k1, a0, a1, b0, b1, c0, c1, r);
                dist = sum(((real_output - approx_output)) ...
                         .*((real_output - approx_output)));
                if (dist < dist_min)
                    dist_min = dist;
                    a0_min = a0;
                    a1_min = a1;
                    k1_min = k1;
                end
            end
        end
    end
    if s ~= step
        a0_typ = a0_min;
        a1_typ = a1_min;
        k1_typ = k1_min;
        dist_min = 1e6;
        a0_min = 0;
        a1_min = 0;
        k1_min = 0;
    end
end
fprintf("Decision Result: (a0: %.20f, a1: %.20f, k1: %.20f)\n", a0_typ, a1_typ, k1_typ);
fprintf("%.20f", dist_min);

approx_output = approx_func(input, k0, k1_typ, a0_typ, a1_typ, b0, b1, c0, c1, r);

figure
scatter(input, real_output);
hold on;
scatter(input, approx_output);
xlim([min(input) max(input)])

function y = sigmoid(x)
    y = 1 ./ (1+exp(-x));
end

function y = cos_sim(x0, x1)
    y=dot(x0, x1)./(vecnorm(x0, 2, 1).*vecnorm(x1, 2, 1));
end
