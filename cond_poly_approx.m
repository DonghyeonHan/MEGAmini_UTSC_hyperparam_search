clear;
clc;

% Target Function
target = 'sigmoid';
if strcmp(target , 'tanh')
    input = [-3: 0.001: 3];
    real_output = tanh(input);
elseif strcmp(target , 'sigmoid')
    input0 = [-5.5: 0.001: -1.5];
    input1 = [ 1.5: 0.001:  5.5];
    input = [input0, input1];
    real_output = sigmoid(input);
elseif strcmp(target , 'sigmoid_gelu')
    input = [-4: 0.001: 4];
    real_output = sigmoid(1.702*input);
end

% Hyper Parameters
a0 = 0.0;
a1 = 0.0;
r = 0.0;
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
r = -1;
avg_err_1sigma_orig = [];
avg_err_1sigma_inlier = [];
avg_err_1sigma_outlier = [];
sigma_range = [0.02:0.02:2.1];
for i = 1:size(sigma_range, 2)
    fprintf("(%d/%d)\n", i, size(sigma_range, 2));
    sigma = sigma_range(i);
    input = [-5.0: 0.001: 5.0];
    input = sigma*randn(512, 10000);
    real_output = sigmoid(input);

    %Entire Range
    a0_typ = 3.8027;
    a1_typ = 4.8867;
    k1_typ = 0.3280;
    approx_output_orig = approx_func(input, k0, k1_typ, a0_typ, a1_typ, b0, b1, c0, c1, r);

    %Optimized for inlier
    a0_typ = 3.7832;
    a1_typ = 4.5469;
    k1_typ = 0.3806;
    approx_output_inlier = approx_func(input, k0, k1_typ, a0_typ, a1_typ, b0, b1, c0, c1, r);

    %Optimized for outlier
    a0_typ = 3.8896;
    a1_typ = 5.5371;
    k1_typ = 0.2391;
    approx_output_outlier = approx_func(input, k0, k1_typ, a0_typ, a1_typ, b0, b1, c0, c1, r);

    avg_err_1sigma_orig = [avg_err_1sigma_orig, mean(cos_sim(approx_output_orig.*input, real_output.*input))];
    avg_err_1sigma_inlier = [avg_err_1sigma_inlier, mean(cos_sim(approx_output_inlier.*input, real_output.*input))];
    avg_err_1sigma_outlier = [avg_err_1sigma_outlier, mean(cos_sim(approx_output_outlier.*input, real_output.*input))];
end

figure
% bar([mean(sum(abs(approx_output_orig-real_output))), ...
%      mean(sum(abs(approx_output_inlier-real_output))), ...
%      mean(sum(abs(approx_output_outlier-real_output)))]);
bar([mean(cos_sim(approx_output_orig, real_output)), ...
     mean(cos_sim(approx_output_inlier, real_output)), ...
     mean(cos_sim(approx_output_outlier, real_output))]);
input = sigma_range;
plot(input,avg_err_1sigma_orig, input,avg_err_1sigma_inlier, input,avg_err_1sigma_outlier);

function y = sigmoid(x)
    y = 1 ./ (1+exp(-x));
end

function y = cos_sim(x0, x1)
    y=dot(x0, x1)./(vecnorm(x0, 2, 1).*vecnorm(x1, 2, 1));
end
