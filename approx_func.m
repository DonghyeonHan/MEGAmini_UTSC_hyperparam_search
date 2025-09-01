              function y = approx_func(x, k0, k1, a0, a1, b0, b1, c0, c1, r)

    a0_ = custom_fp(a0, 5, 10);
    a1_ = custom_fp(a1, 5, 10);
    b0_ = custom_fp(b0, 5, 10);
    b1_ = custom_fp(b1, 5, 10);
    c0_ = custom_fp(c0, 5, 10);
    c1_ = custom_fp(c1, 5, 10);

%     a0_ = custom_fp(a0, 4, 3);
%     a1_ = custom_fp(a1, 4, 3);
%     b0_ = custom_fp(b0, 4, 3);
%     b1_ = custom_fp(b1, 4, 3);
%     c0_ = custom_fp(c0, 4, 3);
%     c1_ = custom_fp(c1, 4, 3);
    
    if r == -1
        %r = 2*(a0_*a1_)/(a0_+a1_);
        %r = (sqrt(k0)+sqrt(k1))*(a0_*a1_)/(a0_*sqrt(k1)+a1_*sqrt(k0));
        r = (sqrt(k0)-sqrt(k1))*(a0_*a1_)/(-a0_*sqrt(k1)+a1_*sqrt(k0));
    end
    
    mask0 = abs(x) <= r;
    %mask1 = (abs(x) > r) & (abs(x) < 5);
    y0 = -(k0.*sign(x)/(a0_*a0_)).*(x-a0_.*sign(x)).*(x-a0_.*sign(x))+b0_*sign(x)+c0_;
%     fprintf("a:%f, c:%f, b:%f, Th0:%f\n", k0./(a0_*a0_), a0_, c0_+b0_, r);
    y1 = -(k1.*sign(x)/(a1_*a1_)).*(x-a1_.*sign(x)).*(x-a1_.*sign(x))+b1_*sign(x)+c1_;
%     fprintf("a:%f, c:%f, b:%f\n", k1./(a1_*a1_), a1_, c1_+b1_)
    y1(mask0) = y0(mask0);
    
    y = y1;
end
